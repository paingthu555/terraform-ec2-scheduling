resource "aws_iam_policy" "policy" {
  name        = "ec2_schedule_policy"
  path        = "/"
  description = "ec2_schedule_policy"
  policy = file("${path.module}/ec2_schedule_policy.json")

#   policy = jsonencode(
#     {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogGroup",
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents"
#             ],
#             "Resource": "arn:aws:logs:*:*:*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:Start*",
#                 "ec2:Stop*"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
#   )
}

resource "aws_iam_role" "lambda_schedule_role" {
  name = "lambda_schedule_role"

  assume_role_policy = file("${path.module}/lambda_schedule_role.json")
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = file("${path.module}/lambda_exec_role.json")
}


resource "aws_iam_policy_attachment" "ec2_auto_attach" {
  name       = "ec2_stop_start_policy_attachment"
  roles      = [aws_iam_role.lambda_schedule_role.name]
  policy_arn = aws_iam_policy.policy.arn
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attachment" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.lambda_exec_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_schedule_policy_attachment" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.lambda_schedule_role.name
}