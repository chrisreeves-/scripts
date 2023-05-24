CLIENTID="REDACTED"
CLIENTSECRET="REDACTED"
CID="REDACTED"
API="REDACTED"
INST_TOKEN="REDACTED"
DATA_PATH="REDACTED"
NAME="REDACTED"
TAGS="region/apsoutheast2,environment/production,name/$NAME,cloud/aws"

sudo apt update

# Getting Crowdstrike Bearer token
if [ -z "$CLIENTID" ] && [ -z "$CLIENTSECRET" ]; then
  echo "Could not read CLIENTID and CLIENTSECRET environment variables"
  exit 1
else
  echo "Requesting bearer token"
  TOKENRESPONSE=$(curl -X POST "https://$API/oauth2/token" -H "accept: application/json" -H "Content-Type: application/x-www-form-urlencoded" -d "client_id=$CLIENTID&client_secret=$CLIENTSECRET" --silent | jq -r '.access_token') 2>/dev/null
fi

# Getting list of Ubuntu installer hashes that support 14.xx, 16.xx, 18.xx, 20.xx
FILENAME=$(curl -X GET "https://$API/sensors/combined/installers/v1" -H "accept: application/json" -H "Authorization: Bearer $TOKENRESPONSE" -H "Content-Type: application/json" --silent | jq -r '.resources[] | select( .os_version | contains("16/18/20"))'.name | awk 'NR==1{print $1}')
SHA=$(curl -X GET "https://$API/sensors/combined/installers/v1" -H "accept: application/json" -H "Authorization: Bearer $TOKENRESPONSE" -H "Content-Type: application/json" --silent | jq -r '.resources[] | select( .os_version | contains("16/18/20"))'.sha256 | awk 'NR==1{print $1}')

# Downloading Latest Crowdstrike
if [ ! -f $data_path/installs/$FILENAME ]
then
    echo "Crowdstrike Falcon agent binary does not exist, downloading ..."
    curl -X GET "https://$API/sensors/entities/download-installer/v1?id=$SHA" -H "accept: application/json" -H "Authorization: Bearer $TOKENRESPONSE" -o $DATA_PATH/installs/$FILENAME
else
    echo "Crowdstrike Falcon agent already downloaded ..."
fi

# Installing ubuntu 20.04 dependancies for crowdstrike linux sensor
sudo apt update

# Install CS dependancies for Ubuntu 20.04. No harm included in 22.04 to keep builds standardised.
sudo apt install libnl-3-200 libnl-genl-3-200 -y

# Install Crowdstrike
sudo dpkg -i $DATA_PATH/installs/$FILENAME

# Apply CID
sudo /opt/CrowdStrike/falconctl -s --cid=$CID --tags="${TAGS}" --provisioning-token=${INST_TOKEN}

# Start Falcon
sudo systemctl start falcon-sensor

# Enable on boot
sudo systemctl enable falcon-sensor

# Check Crowdstrike Falcon registration
RESPONSE=$(curl -s -X GET "https://$API/devices/queries/devices/v1?filter=hostname:wresat-web" -H "Authorization: Bearer $TOKENRESPONSE")
DEVICE_ID=$(echo "$RESPONSE" | jq -r '.resources[0].device_id')
LAST_SEEN=$(echo "$RESPONSE" | jq -r '.resources[0].last_seen')
echo "Device ID: $DEVICE_ID"
echo "Last Seen: $LAST_SEEN"

