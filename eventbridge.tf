## Creating EventBridge Scheduler to trigger Lambda functions
resource "aws_scheduler_schedule" "EC2_start_schedule" {
  name        = "EC2_start_schedule"
  group_name  = "default"

  schedule_expression = "cron(*/2 * * * ? *)"
  flexible_time_window { mode = "OFF" }

  target {
    arn      = aws_lambda_function.ec2_start.arn
    role_arn = aws_iam_role.lambda_schedule_role.arn
  }
}

resource "aws_scheduler_schedule" "EC2_stop_schedule" {
  name        = "EC2_stop_schedule"
  group_name  = "default"

  schedule_expression = "cron(*/5 * * * ? *)"
  flexible_time_window { mode = "OFF" }

  target {
    arn      = aws_lambda_function.ec2_stop.arn
    role_arn = aws_iam_role.lambda_schedule_role.arn
  }
}
