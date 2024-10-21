provider "aws" {
  region     = var.region_aws
  access_key = var.acces_key
  secret_key = var.secret_key
}

resource "aws_s3_object" "app_object" {
  bucket = var.bucket_name
  key    = var.key_object_zip
  source = var.source_objet_local
}

resource "aws_codedeploy_app" "app" {
  name             = var.name_codedeploy_application
  compute_platform = var.compute_platform_name
  tags = {
    key   = "Enviroment"
    value = "dev"
  }
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = var.deployment_group_name_codedeploy
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  deployment_style {
    deployment_type = var.deployment_type

  }
}

resource "aws_iam_role" "codedeploy_role" {
  name               = var.codedeploy_role_name
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_policy.json
  tags = {
    Environment = "dev"
    Project     = "MyApp"
  }
}

data "aws_iam_policy_document" "codedeploy_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy_role.name
}


