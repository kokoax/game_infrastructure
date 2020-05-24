#!/usr/bin/env python
# -*- coding: utf-8 -*-

import boto3
import time

spot_price                 = '0.15'
instance_count             = 1
request_type               = 'request'
image_id                   = 'ami-032264be6c6f08f3c'
security_group_id          = 'sg-03e83d20acec854f7'
instance_type              = 'c5.xlarge'
availability_zone          = 'ap-northeast-1d'
subnet_id                  = 'subnet-0b81492c6a43fa421'
game_name_tag              = "GameName"
spot_instance_request_name = '7dtd'

client = boto3.client('ec2')

def lambda_handler(event, context):
    response = client.describe_spot_instance_requests(
            Filters=[ { 'Name': 'state', 'Values': [ 'active' ] } ]
            )
    # spot instance already exists
    request_body = response[list(response.keys())[0]]
    for request_id in request_body:
        for tag in request_id['Tags']:
            if tag['Key'] == game_name_tag and tag['Value'] == spot_instance_request_name:
                return { 'statusCode': '500', 'body': 'spot instance already exists' }

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
                'SubnetId': subnet_id
                }
            )
    time.sleep(1)
    request_body = response[list(response.keys())[0]]
    for request_id in request_body:
        response = client.create_tags(
                Resources=[ request_id['SpotInstanceRequestId'] ],
                Tags=[ { 'Key': game_name_tag, 'Value': spot_instance_request_name } ]
                )
