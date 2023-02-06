from shodan import Shodan

shodan_api = "YOUR-SHODAN-API-KEY"
name = "Alert Name Here"
cidr_vm = "IP-TO-MONITOR"

# Connect
api = Shodan(shodan_api)

# Create Alert
api.create_alert(name=name, ip=cidr_vm, expires=0)

# Get Alert ID
data = api.alerts(include_expired=True)
for i in data:
    alert = i['name']
    if alert == name:
        alert_id = i['id']

# Add Alert Triggers
api.enable_alert_trigger(aid=alert_id,
                         trigger='industrial_control_system,internet_scanner,iot,malware,new_service,open_database,ssl_expired,vulnerable')

# Add Alert Notifications
api.add_alert_notifier(aid=alert_id, nid='default')
