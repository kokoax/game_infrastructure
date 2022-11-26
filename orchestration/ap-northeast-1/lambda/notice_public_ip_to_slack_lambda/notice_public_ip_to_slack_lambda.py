#!/usr/bin/python
# -*- coding: utf-8 -*-

import json
import os
import base64
import urllib.request
import boto3

client = boto3.client('ec2')

def get_decript_key(text):
  kms = boto3.client('kms')
  return kms.decrypt(CiphertextBlob=base64.b64decode(text))['Plaintext'].decode('utf-8')

def lambda_handler(event, context):
    instance_id = event['detail']['instance-id']
    response = client.describe_instances(InstanceIds=[instance_id])
    instance = response['Reservations'][0]['Instances'][0]
    url = get_decript_key(os.environ['ENCRYPTED_SLACK_WEBHOOK'])
    fields = []
    fields.append({
        'title': 'Public IP',
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
