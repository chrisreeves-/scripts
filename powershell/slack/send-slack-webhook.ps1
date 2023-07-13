 $webhookUrl = "https://hooks.slack.com/services/XX/YY/ZZ"

# Create the payload object
$payload = @{
    text = "Hello from PowerShell!"
    channel = "#test-alerts"
    username = "Your name"
}

# Convert the payload to JSON
$jsonPayload = $payload | ConvertTo-Json

# Send the payload to the Slack webhook
Invoke-RestMethod -Method Post -Uri $webhookUrl -Body $jsonPayload -ContentType "application/json"
