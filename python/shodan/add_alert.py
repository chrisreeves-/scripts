import click
import shodan
from shodan import Shodan

shodan_api = "YOUR-SHODAN-API-KEY"
name = "Alert Name Here"
cidr_vm = "IP-TO-MONITOR"

# Connect
try:
    api = Shodan(shodan_api)
    print(f"HTTP 200 - Connected to Shodan API")
except shodan.APIError as e:
    raise click.ClickException(e.value)

# Create Alert
try:
    api.create_alert(name=name, ip=cidr_vm, expires=0)
    print(f"HTTP 200 - Created alert {name}")
except shodan.APIError as e:
    raise click.ClickException(e.value)

# Get Alert ID
try:
    data = api.alerts(include_expired=True)
    for i in data:
        alert = i['name']
        if alert == name:
            alert_id = i['id']
    print(f"HTTP 200 - Retrieved alert ID={alert_id}")
except shodan.APIError as e:
    raise click.ClickException(e.value)

# Add Alert Triggers
try:
    api.enable_alert_trigger(aid=alert_id,
                             trigger='industrial_control_system,internet_scanner,iot,malware,new_service,open_database,ssl_expired,vulnerable')
    print(f"HTTP 200 - Added triggers to ID={alert_id}")
except shodan.APIError as e:
    raise click.ClickException(e.value)


# Add Alert Notifications
try:
    api.add_alert_notifier(aid=alert_id, nid='default')
except shodan.APIError as e:
    raise click.ClickException(e.value)