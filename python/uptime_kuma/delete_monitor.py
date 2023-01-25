from uptime_kuma_api import UptimeKumaApi

kuma_endpoint = ""
username_kuma = ""
password_kuma = ""
vm_name = ""

# Connect
api = UptimeKumaApi(kuma_endpoint)
api.login(username_kuma, password_kuma)

# Get Monitor Funct
def get_monitor():
    result = api.get_monitors()
    for monitors in result:
        name = monitors['name']
        if name == vm_name:
            vm_name_id = monitors['id']
            return vm_name_id


# Delete Monitor Funct
def delete_monitor(monitor_id):
    api.delete_monitor(monitor_id)


try:
    monitor_id = get_monitor()
    print(f"Found id for monitor matching the name {vm_name}")
except:
    print(f"Could not find ID for monitor matching the name {vm_name}")
try:
    delete_monitor(monitor_id)
    print(f"Deleted monitor with the ID of {monitor_id} that matched the name {vm_name}")
except:
    print("Could not delete monitor")

# Disconnect
api.disconnect()