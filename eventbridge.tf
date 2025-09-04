# resource "aws_cloudwatch_event_rule" "morning_rule" {
#   name        = "morning_rule"
#   description = "Rule to trigger Lambda function at 8:30 AM"
#   schedule_expression = "cron(30 8 * * ? *)"

# }

# resource "aws_cloudwatch_event_rule" "evening_rule" {
#   name        = "evening_rule"
#   description = "Rule to trigger Lambda function at 5:30 PM"
#   schedule_expression = "cron(30 17 * * ? *)"

# }

# resource "aws_cloudwatch_event_target" "morning_lambda_target" {
#   rule      = aws_cloudwatch_event_rule.morning_rule.name
#   arn       = aws_lambda_function.ec2_start.arn
#   target_id = "morning_lambda_target"
# }

# resource "aws_cloudwatch_event_target" "evening_lambda_target" {
#   rule      = aws_cloudwatch_event_rule.evening_rule.name
#   arn       = aws_lambda_function.ec2_stop.arn
#   target_id = "evening_lambda_target"
# }


# resource "aws_lambda_permission" "ec2_start_perm" {
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.ec2_start.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.morning_rule.arn
# }

# resource "aws_lambda_permission" "ec2_stop_perm" {
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.ec2_stop.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.evening_rule.arn
# }

resource "aws_scheduler_schedule" "morning" {
  name        = "morning_schedule"
  group_name  = "default"

  schedule_expression = "cron(30 8 * * ? *)"
  flexible_time_window { mode = "OFF" }

  target {
    arn      = aws_lambda_function.ec2_start.arn
    role_arn = aws_iam_role.lambda_schedule_role.arn
    # input    = jsonencode({})  # optional payload
  }
}

resource "aws_scheduler_schedule" "evening" {
  name        = "evening_schedule"
  group_name  = "default"

  schedule_expression = "cron(30 17 * * ? *)"
  flexible_time_window { mode = "OFF" }

  target {
    arn      = aws_lambda_function.ec2_stop.arn
    role_arn = aws_iam_role.lambda_schedule_role.arn
    # input    = jsonencode({})
  }
}
