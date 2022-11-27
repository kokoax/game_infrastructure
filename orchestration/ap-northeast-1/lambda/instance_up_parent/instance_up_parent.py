#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib.parse
import boto3
import json

client = boto3.client('lambda')

def lambda_handler(event, context):
    print("start progress")
    print(event)
    print(context)
    game = urllib.parse.parse_qs(event['qp'])["text"][0]
    boto3.client('lambda').invoke(
        FunctionName='instance_up',
        InvocationType='Event',
        Payload=json.dumps({"game": game })
    )
    print("end progress")
