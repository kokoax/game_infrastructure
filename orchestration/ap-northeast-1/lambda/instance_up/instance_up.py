#!/usr/bin/env python
# -*- coding: utf-8 -*-

import boto3
import time

game_info = {
    '7dtd': {
        'image_id': 'ami-0ad2296f162940437',
        'security_group_id': 'sg-035b3b7462e2f9ca5',
        'subnet_id': 'subnet-03a819f63008541e1',
        'spot_instance_request_name': '7dtd'
    },
    'ark': {
        'image_id': 'ami-0611486aa63a5919d',
        'security_group_id': 'ark_security_group',
        'subnet_id': 'subnet-0027d26b218ed92da',
        'spot_instance_request_name': 'ark'
    }
}

spot_price        = '0.15'
instance_count    = 1
request_type      = 'request'
instance_type     = 'c5.xlarge'
availability_zone = 'ap-northeast-1d'
game_name_tag     = "GameName"

client = boto3.client('ec2')

def lambda_handler(event, context):
    print("start progress")
    print(event)
    print(context)
    game_name = event.get('game')
    image_id                   = game_info[game_name]["image_id"]
    security_group_id          = game_info[game_name]["security_group_id"]
    subnet_id                  = game_info[game_name]["subnet_id"]
    spot_instance_request_name = game_info[game_name]["spot_instance_request_name"]

    response = client.describe_spot_instance_requests(
            Filters=[ { 'Name': 'state', 'Values': [ 'active' ] } ]
            )
    # spot instance already exists
    request_body = response[list(response.keys())[0]]
    for request_id in request_body:
        for tag in request_id['Tags']:
            if tag['Key'] == game_name_tag and tag['Value'] == spot_instance_request_name:
                return { 'statusCode': '500', 'body': 'spot instance already exists' }

    print("request spot instance start")
    response = client.request_spot_instances(
            DryRun=False,
            SpotPrice=spot_price,
            InstanceCount=1,
            Type='one-time',
            LaunchSpecification={
                'ImageId': image_id,
                'SecurityGroupIds': [security_group_id],
                'InstanceType': instance_type,
                'Placement': { 'AvailabilityZone': availability_zone },
                'SubnetId': subnet_id,
                }
            )
    print("request spot instance end")
    time.sleep(1)
    print("sleeped 1s")
    request_body = response[list(response.keys())[0]]
    for request_id in request_body:
        response = client.create_tags(
                Resources=[ request_id['SpotInstanceRequestId'] ],
                Tags=[ { 'Key': game_name_tag, 'Value': spot_instance_request_name } ]
                )
    print("end progress")
