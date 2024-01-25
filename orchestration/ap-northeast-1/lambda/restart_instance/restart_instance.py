# instance_id
# instance_idを探す
# 再起動する

import boto3

client = boto3.client('ec2')

def lambda_handler(event, context):
    client.reboot_instances(
        InstanceIds=[
            'i-079d948ff8f478b20'
        ]
    )
