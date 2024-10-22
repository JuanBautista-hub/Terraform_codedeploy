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

}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = var.deployment_group_name_codedeploy
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  deployment_style {
    deployment_type = var.deployment_type

  }
  tags = {
    Environment = var.Environment
  }
  on_premises_instance_tag_filter {
    key   = "Environment"
    value = var.Environment
    type  = "KEY_AND_VALUE"

  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  outdated_instances_strategy = "UPDATE"
}


resource "aws_iam_role" "codedeploy_role" {
  name               = var.codedeploy_role_name
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_policy.json
  tags = {
    Environment = var.Environment
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


resource "null_resource" "create_deployment" {
  provisioner "local-exec" {
    command = <<EOT
      aws deploy create-deployment --application-name ${var.name_codedeploy_application} --deployment-group-name ${var.deployment_group_name_codedeploy} --s3-location bucket=${var.bucket_name},key=${var.key_object_zip},bundleType=zip --region ${var.region_aws}
    EOT
  }

  depends_on = [aws_codedeploy_deployment_group.deployment_group] # Asegúrate de que tu grupo de implementación ya exista
}
