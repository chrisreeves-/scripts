import click
import shodan
from shodan import Shodan

shodan_api = "YOUR-SHODAN-API-KEY"
name = "Alert Name Here"

# Connect
try:
    api = Shodan(shodan_api)
    print(f"HTTP 200 - Connected to Shodan API")
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

# Delete Alert
try:
    api.delete_alert(aid=alert_id)
    print(f"HTTP 200 - Deleted alert ID={alert_id}")
except shodan.APIError as e:
    raise click.ClickException(e.value)