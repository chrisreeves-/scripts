from shodan import Shodan

shodan_api = "YOUR-SHODAN-API-KEY"
name = "Alert Name Here"

# Connect
api = Shodan(shodan_api)

# Get Alert ID
data = api.alerts(include_expired=True)
for i in data:
    alert = i['name']
    if alert == name:
        alert_id = i['id']

# Delete Alert
api.delete_alert(aid=alert_id)
