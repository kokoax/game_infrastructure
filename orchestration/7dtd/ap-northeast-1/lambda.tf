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

resource "aws_lambda_function" "instance_up_lambda" {
  filename      = "lambda/instance_up/lambda_handler.zip"
  function_name = "7dtd_instance_up"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "instance_up.lambda_handler"
  timeout       = 60

  source_code_hash = filebase64sha256("lambda/instance_up/lambda_handler.zip")

  runtime = "python3.7"
}

resource "aws_lambda_function" "instance_down_lambda" {
  filename      = "lambda/instance_down/lambda_handler.zip"
  function_name = "7dtd_instance_down"
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

  runtime = "python3.7"
}

resource "aws_cloudwatch_event_rule" "notice_public_ip_to_slack_lambda_event_rule" {
  name = "notice_public_ip_to_slack_lambda_event_rule"
  description = "notice ec2 public ip to slack"
  event_pattern = <<PATTERN
{
  "source": [ "aws.ec2" ],
  "detail-type": [ "EC2 Instance State-change Notification" ],
  "detail": {
    "state": [ "running" ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "notice_public_ip_to_slack_lambda_event_target" {
  rule      = aws_cloudwatch_event_rule.notice_public_ip_to_slack_lambda_event_rule.name
  target_id = "notice_public_ip_to_slack_lambda"
  arn       = aws_lambda_function.notice_public_ip_to_slack_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_notice_public_ip_to_slack" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.notice_public_ip_to_slack_lambda.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.notice_public_ip_to_slack_lambda_event_rule.arn
}
