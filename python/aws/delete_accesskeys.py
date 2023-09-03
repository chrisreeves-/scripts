import boto3

username = ["iam_user1", "iam_user2", "iam_user3", "iam_user4"]
aws_access_key_id="" # Add your AWS access key
aws_secret_access_key="" # Add your AWS secret
region_name="" # Add your AWS region

# Connect to AWS
iam = boto3.client('iam',
                   aws_access_key_id=aws_access_key_id,
                   aws_secret_access_key=aws_secret_access_key,
                   region_name=region_name)

# Delete AWS Access Key for users in list
try:
    for user in username:
        paginator = iam.get_paginator('list_access_keys')
        for response in paginator.paginate(UserName=user):
            result = response['AccessKeyMetadata']
            for key in result:
                access_key = key['AccessKeyId']
                if access_key:
                    iam.delete_access_key(
                        AccessKeyId=access_key,
                        UserName=user)
                    print(f"Deleted access key {access_key} for username {user}")
except:
    print(f"Could not delete access key {access_key} for username {user}")