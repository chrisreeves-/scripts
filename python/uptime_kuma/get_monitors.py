from uptime_kuma_api import UptimeKumaApi, MonitorType

kuma_endpoint = ""
username_kuma = ""
password_kuma = ""
cidr_vm = ""
vm_name = ""

# Connect
api = UptimeKumaApi(kuma_endpoint)
api.login(username_kuma, password_kuma)

# Get Monitor
result = api.get_monitors()

# Disconnect
api.disconnect()
