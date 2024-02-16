resource "aws_scheduler_schedule" "_palworld_restart_instance" {
  name       = "palworld_restart_instance"
  group_name = "default"
  schedule_expression_timezone = "Asia/Tokyo"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(0 10 * * ? *)"

  target {
    arn      = aws_lambda_function.restart_instance.arn
    role_arn = aws_iam_role.restart_instance.arn
  }
}
