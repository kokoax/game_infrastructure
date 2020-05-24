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
