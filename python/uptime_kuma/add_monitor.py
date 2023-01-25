from uptime_kuma_api import UptimeKumaApi, MonitorType

kuma_endpoint = ""
username_kuma = ""
password_kuma = ""
cidr_vm = ""
vm_name = ""

# Connect to Uptime Kuma
try:
    api = UptimeKumaApi(kuma_endpoint)
    api.login(username_kuma, password_kuma)
except:
    print("Could not connect to Uptime Kuma")

# Get Monitor
result = api.get_monitors()
for monitors in result:
    name = monitors['name']
    if name == vm_name:
        vm_name_id = monitors['id']


# Add Monitor
try:
    if name == vm_name:
        print("Uptime Kuma monitor already exists")
    else:
        result = api.add_monitor(type=MonitorType.PING, name=vm_name, hostname=cidr_vm)
        print(result)
except:
    print("Could not add monitor to Uptime Kuma")


# Disconnect from Uptime Kuma
api.disconnect()
