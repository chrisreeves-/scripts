import requests
import os
import json

'''
Built Date: 21st December 2023
Built By: Chris Reeves

API Documentation: https://securityheaders.com/api/docs/

Requirements:
1. Input variables for Security Header API key and Discord webhook URL
2. pip3 install requests json

Security headers source ipv4: https://securityheaders.com/.well-known/ipv4.txt
Security headers source ipv6: https://securityheaders.com/.well-known/ipv6.txt
'''

domains = ["example.com", "example.org"]
hide = "on" # Turn on to hide results from securityheaders website results
followRedirects = "on"
api_key = os.environ.get('api_key')
headers = {
    "x-api-key": api_key
}
webhook_url = os.environ.get('webhook_url')

for domain in domains:
    try:
        api_url = f"https://api.securityheaders.com/?q={domain}&hide={hide}&followRedirects={followRedirects}"
        response = requests.get(api_url, headers=headers).json()
        timestamp = response["summary"]["timestamp"]
        site = response["summary"]["site"]
        status = response["status"]
        grade = response["summary"]["grade"]
        sts = response["summary"]["headers"]["Strict-Transport-Security"]  # Strict-Transport-Security
        csp = response["summary"]["headers"]["Content-Security-Policy"]  # Content-Security-Policy
        pm = response["summary"]["headers"]["Permissions-Policy"]  # Permissions-Policy
        refpol = response["summary"]["headers"]["Referrer-Policy"]  # Referrer-Policy
        xcto = response["summary"]["headers"]["X-Content-Type-Options"]  # X-Content-Type-Options
        xxp = response["summary"]["headers"]["X-Frame-Options"]  # X-XSS-Protection
        payload = (f"Timestamp: {timestamp}" \
                   + "\n" + f"Domain: {site}" \
                   + "\n" + f"Status: {status.title()}" \
                   + "\n" + f"Grade: {grade}" \
                   + "\n" + f"Strict-Transport-Security: {sts.title()}" \
                   + "\n" + f"Content-Security-Policy: {csp.title()}" \
                   + "\n" + f"Permissions-Policy: {pm.title()}" \
                   + "\n" + f"Referrer-Policy-Policy: {refpol.title()}" \
                   + "\n" + f"X-Content-Type-Options: {xcto.title()}" \
                   + "\n" + f"X-Frame-Options: {xxp.title()}")
    except:
        print("Error: Could not find domain")

    def send_discord_webhook(webhook_url, payload):
        payload = {
            "content": payload
        }

        headers = {
            "Content-Type": "application/json"
        }

        response = requests.post(webhook_url, data=json.dumps(payload), headers=headers)
        return response.status_code


    try:
        status_code = send_discord_webhook(webhook_url, payload)
    except:
        print("Error: Could not send webhook")
