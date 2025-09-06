# Allows Lambda to log to CloudWatch and start/stop EC2
resource "aws_iam_policy" "ec2_schedule_policy" {
  name        = "ec2_schedule_policy"
  policy = file("${path.module}/ec2_schedule_policy.json")

}

# Allow EventBridge Scheduler can invoke the Lambda functions
resource "aws_iam_policy" "scheduler_invoke_lambda" {
  name        = "scheduler_invoke_lambda"
  policy = templatefile("${path.module}/scheduler_invoke_lambda_policy.json", {
    ec2_start_arn = aws_lambda_function.ec2_start.arn,
    ec2_stop_arn  = aws_lambda_function.ec2_stop.arn
  })
}

# Trust policy for EventBridge Scheduler.
resource "aws_iam_role" "eventbridge_schedule_role" {
  name = "eventbridge_schedule_role"
  assume_role_policy = file("${path.module}/eventbridge_schedule_role.json")
}

# Trust policy for Lambda execution.
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = file("${path.module}/lambda_exec_role.json")
}

# Attach ec2_schedule_policy to eventbridge_schedule_role
resource "aws_iam_role_policy_attachment" "ec2_stop_start_policy_attach" {
  role       = aws_iam_role.eventbridge_schedule_role.name
  policy_arn = aws_iam_policy.ec2_schedule_policy.arn
}

# Attach with ec2_schedule_policy to lambda_exec_role
resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.ec2_schedule_policy.arn
}

# Attach with scheduler_invoke_lambda to lambda_schedule_role
resource "aws_iam_role_policy_attachment" "scheduler_invoke_lambda_attach" {
  role       = aws_iam_role.eventbridge_schedule_role.name
  policy_arn = aws_iam_policy.scheduler_invoke_lambda.arn
}