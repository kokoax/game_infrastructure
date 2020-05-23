#!/usr/bin/env python
# -*- coding: utf-8 -*-

import boto3
import datetime

game_name_tag = "GameName"
spot_instance_request_name = '7dtd'

client = boto3.client('ec2')

def lambda_handler(event, context):
    response = client.describe_spot_instance_requests(
            Filters=[ { 'Name': 'state', 'Values': [ 'active' ] } ]
            )
    request_body = response[list(response.keys())[0]]
    for request_id in request_body:
        for tag in request_id['Tags']:
            if tag['Key'] == game_name_tag and tag['Value'] == spot_instance_request_name:
                response = client.cancel_spot_instance_requests(
                        SpotInstanceRequestIds=[ request_id['SpotInstanceRequestId'] ]
                        )
