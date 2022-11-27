#!/usr/bin/env python
# -*- coding: utf-8 -*-

import boto3
import json

client = boto3.client('lambda')

def lambda_handler(event, context):
    print("start progress")
    print(event)
    boto3.client('lambda').invoke(
        FunctionName='instance_up',
        InvocationType='Event',
        Payload=json.dumps(event)
    )
    print("end progress")
