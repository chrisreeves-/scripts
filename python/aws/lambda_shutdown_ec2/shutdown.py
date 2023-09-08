import os
import boto3

# Replace these with your AWS credentials and region
aws_access_key = os.environ['ACCESS_KEY']
aws_secret_key = os.environ['SECRET_KEY']
aws_region = os.environ['REGION']

# Create a session using your credentials
session = boto3.Session(
    aws_access_key_id=aws_access_key,
    aws_secret_access_key=aws_secret_key,
    region_name=aws_region
)

# Create an EC2 client using the session
ec2_client = session.client('ec2')

# Define the tag key and value to look for
tag_key = 'Environment'
tag_value = 'Development'

def shutdown_dev_instances(tag_key, tag_value):
    # Get a list of all instances with the specified tag and value
    response = ec2_client.describe_instances(
        Filters=[
            {
                'Name': f'tag:{tag_key}',
                'Values': [tag_value]
            }
        ]
    )
    # Shutdown instances
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            print(f"Stopping instance {instance_id}")
            ec2_client.stop_instances(InstanceIds=[instance_id])


def lambda_handler(event, context):
    print("Starting lambda")
    shutdown_dev_instances(tag_key, tag_value)
    print("Finished lambda")
