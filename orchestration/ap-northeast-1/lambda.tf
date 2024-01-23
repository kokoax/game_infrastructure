resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "for_lambda" {
  name   = "iam_role_policy"
  role   = aws_iam_role.iam_for_lambda.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "instance_up_parent_lambda" {
  filename      = "lambda/instance_up_parent/lambda_handler.zip"
  function_name = "instance_up_parent"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "instance_up_parent.lambda_handler"
  timeout       = 60

  source_code_hash = filebase64sha256("lambda/instance_up_parent/lambda_handler.zip")

  runtime = "python3.7"
}

resource "aws_lambda_function" "instance_up_lambda" {
  filename      = "lambda/instance_up/lambda_handler.zip"
  function_name = "instance_up"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "instance_up.lambda_handler"
  timeout       = 60

  source_code_hash = filebase64sha256("lambda/instance_up/lambda_handler.zip")

  runtime = "python3.7"
}

resource "aws_lambda_function" "instance_down_lambda" {
  filename      = "lambda/instance_down/lambda_handler.zip"
  function_name = "instance_down"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "instance_down.lambda_handler"
  timeout       = 60

  source_code_hash = filebase64sha256("lambda/instance_down/lambda_handler.zip")

  runtime = "python3.7"
}

resource "aws_lambda_function" "notice_public_ip_to_slack_lambda" {
  filename      = "lambda/notice_public_ip_to_slack_lambda/lambda_handler.zip"
  function_name = "notice_public_ip_to_slack_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "notice_public_ip_to_slack_lambda.lambda_handler"
  timeout       = 60

  source_code_hash = filebase64sha256("lambda/notice_public_ip_to_slack_lambda/lambda_handler.zip")
  kms_key_arn      = "arn:aws:kms:ap-northeast-1:886398035123:key/097a43e9-d69e-4923-b358-031210b01d09"

  environment {
    variables = {
      ENCRYPTED_SLACK_WEBHOOK = "AQICAHiRp81+n7J5EkKb8abQ1TUOTvEcUtk8qRwF3ViprAViXAHjq6O2hHiuYEc4+YyLfwC6AAAAsjCBrwYJKoZIhvcNAQcGoIGhMIGeAgEAMIGYBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDCrh7ebsnU1yOPIV8AIBEIBrJDLTWWW3/NyLQdIKtqIbcnYcWnBvRC9Rr/gGas8vTAbCOhnmmS3Y/9uyEcPUfiw95BRW00NbgqkhMuU6zQKXv3d+budc2/g52bv+R3klgmaOT70b3VqfqfMZ4gFqzEMk1Toxr1MnqnpgNDQ="
    }
  }

  runtime = "python3.7"
}

resource "aws_lambda_function" "notice_terminate_to_slack_lambda" {
  filename      = "lambda/notice_terminate_to_slack_lambda/lambda_handler.zip"
  function_name = "notice_terminate_to_slack_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "notice_terminate_to_slack_lambda.lambda_handler"
  timeout       = 60

  source_code_hash = filebase64sha256("lambda/notice_terminate_to_slack_lambda/lambda_handler.zip")
  kms_key_arn      = "arn:aws:kms:ap-northeast-1:886398035123:key/097a43e9-d69e-4923-b358-031210b01d09"

  environment {
    variables = {
      ENCRYPTED_SLACK_WEBHOOK = "AQICAHiRp81+n7J5EkKb8abQ1TUOTvEcUtk8qRwF3ViprAViXAHjq6O2hHiuYEc4+YyLfwC6AAAAsjCBrwYJKoZIhvcNAQcGoIGhMIGeAgEAMIGYBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDCrh7ebsnU1yOPIV8AIBEIBrJDLTWWW3/NyLQdIKtqIbcnYcWnBvRC9Rr/gGas8vTAbCOhnmmS3Y/9uyEcPUfiw95BRW00NbgqkhMuU6zQKXv3d+budc2/g52bv+R3klgmaOT70b3VqfqfMZ4gFqzEMk1Toxr1MnqnpgNDQ="
    }
  }

  runtime = "python3.7"
}

resource "aws_lambda_function" "restart_instance" {
  filename      = "lambda/restart_instance/lambda_handler.zip"
  function_name = "restart_instance"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "restart_instance.lambda_handler"
  timeout       = 60

  source_code_hash = filebase64sha256("lambda/restart_instance/lambda_handler.zip")

  runtime = "python3.7"
}
