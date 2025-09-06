data "archive_file" "ec2_stop_script" {
  type        = "zip"
  source_file = "${path.module}/stop-ec2.py"
  output_path = "stop-ec2.zip"
}

resource "aws_lambda_function" "ec2_stop" {

  filename      = "stop-ec2.zip"
  function_name = "ec2_stop_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "stop-ec2.lambda_handler"
  timeout       = 60

  source_code_hash = data.archive_file.ec2_stop_script.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      REGION      = var.region
      INSTANCE_ID = var.instance_id
    }
  }
}


data "archive_file" "ec2_start_script" {
  type        = "zip"
  source_file = "${path.module}/start-ec2.py"
  output_path = "start-ec2.zip"
}

resource "aws_lambda_function" "ec2_start" {

  filename      = "start-ec2.zip"
  function_name = "ec2_start_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "start-ec2.lambda_handler"
  timeout       = 60

  source_code_hash = data.archive_file.ec2_start_script.output_base64sha256

  runtime = "python3.9"


  environment {
    variables = {
      REGION      = var.region
      INSTANCE_ID = var.instance_id
    }
  }
}