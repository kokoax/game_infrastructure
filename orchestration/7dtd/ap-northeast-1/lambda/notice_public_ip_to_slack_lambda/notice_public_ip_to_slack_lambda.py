#!/usr/bin/python
# -*- coding: utf-8 -*-

import boto3
import urllib.request
import json

url = 'https://hooks.slack.com/services/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'
client = boto3.client('ec2')

def lambda_handler(event, context):
    instance_id = event['detail']['instance-id']
    response = client.describe_instances(InstanceIds=[instance_id])
    instance = response['Reservations'][0]['Instances'][0]
    fields = []
    fields.append({
        'title': 'Name',
        'value': instance["PublicIpAddress"],
        'short': True,
        })
    data = {
            'attachments': [{
                'pretext': '<!here> インスタンスが起動しました',
                'color': 'good',
                'fields': fields,
                }]
            }
    # Slack通知
    req = urllib.request.Request(
            url=url,
            data=json.dumps(data).encode("utf-8"),
            method='POST',
            headers={'Content-Type': 'application/json'})
    urllib.request.urlopen(req)
