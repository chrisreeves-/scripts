# https://www.sophos.com/en-us/medialibrary/PDFs/documentation/UTMonAWS/Sophos-UTM-RESTful-API.ashx

sophos_api="random_restful_api_token_here" # SophosUTM/WebAdmin Settings/RESTful API
name="SERVER_EIP" # The name of the network definition
ref="REF_NetHostxxxx" # The reference of the network definition, get this by doing a HTTP get
eip="1.1.1.1" # Updated IP address

# Update Sophos UTM Network Definition
curl  \
	  -k \
    -s \
    -X PATCH \
    --header 'Content-Type: application/json' \
    --header 'Accept: application/json' \
    --header 'Authorization: Basic '$sophos_api'' \
    -d '{"address":"'$eip'","address6":"","comment":"","duids":[],"hostnames":[],"interface":"","macs":[],"name":"'$name'","resolved":false,"resolved6":false,"reverse_dns":false}' 'https://10.56.10.254:4444/api/objects/network/host/'$ref''