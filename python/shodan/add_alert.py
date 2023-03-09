import sys
import click
import shodan
from shodan import Shodan

'''
Date:        8th March 2023
Author:      Chris Reeves
Description: Checks to see if an existing Shodan asset to monitor
             has been created and creates if none is present then
             checks to make sure it was created if not already.
'''

# Variables
shodan_api = ""
shodan_name = ""
shodan_cidr = ""
triggers = 'industrial_control_system,' \
           'internet_scanner,' \
           'iot,' \
           'malware,' \
           'new_service,' \
           'open_database,' \
           'ssl_expired,' \
           'vulnerable'

# Connect to Shodan
try:
    api = Shodan(shodan_api)
    print(f"HTTP 200 - Connected to Shodan API")
except shodan.APIError as e:
    raise click.ClickException(e.value)

# Checking for existing alert monitor and exit if already exists
data = api.alerts(include_expired=False)
for i in data:
    alert = i['name']
    if alert == shodan_name:
        print("HTTP 500 - Existing asset found ...")
        sys.exit(1)

# Creating alert monitor
api.create_alert(name=shodan_name,
                 ip=shodan_cidr,
                 expires=0)
print(f"HTTP 200 - Created asset {shodan_name} ...")
print("Getting existing asset ...")
results = api.alerts(include_expired=False)
for i in results:
    alert = i['name']
    if alert == shodan_name:
        alert_id = i['id']
        print(f"HTTP 200 - Retrieved asset ID={alert_id}")
        api.enable_alert_trigger(aid=alert_id,
                                 trigger=triggers)
        print(f"HTTP 200 - Added triggers to asset ID={alert_id}")
        api.add_alert_notifier(aid=alert_id,
                               nid='default')

# Check to if the monitor is created
for i in results:
    alert = i['name']
    if alert == shodan_name:
        print("Asset has been created successfully and has been tested ...")
    elif alert == "":
        print("Could not find the new asset ...")
