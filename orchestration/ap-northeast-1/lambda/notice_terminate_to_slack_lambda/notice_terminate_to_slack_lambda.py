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
    url = 'https://hooks.slack.com/services/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'
    data = {
            'attachments': [{
                'pretext': '<!here> インスタンスが停止しました',
                'color': 'good',
                'fields': [],
                }]
            }
    # Slack通知
    req = urllib.request.Request(
            url=url,
            data=json.dumps(data).encode("utf-8"),
            method='POST',
            headers={'Content-Type': 'application/json'})
    urllib.request.urlopen(req)
