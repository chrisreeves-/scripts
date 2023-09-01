import requests
from requests.auth import HTTPBasicAuth

# Replace these variables with your own GitHub username, repository name, and access token
username = 'chrisreeves-'
repository = 'scripts'
access_token = 'ghp_xyz'

# GitHub REST API endpoint to fetch clone statistics
url = f'https://api.github.com/repos/{username}/{repository}/traffic/clones'

# Fetch data using a GET request
response = requests.get(url, auth=HTTPBasicAuth(username, access_token))

# Check if the request was successful
if response.status_code == 200:
    data = response.json()
    print(f"Repository {username}/{repository} has been cloned {data['count']} times in the last 14 days.")
    print(f"Repository {username}/{repository} has had {data['uniques']} unique cloners in the last 14 days.")
else:
    print(f"Failed to fetch data: {response.status_code}, {response.reason}")
