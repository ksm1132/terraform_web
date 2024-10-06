variable "github_token" {}

resource "aws_codepipeline" "example" {
  name     = "example"
  role_arn = module.codepipeline_role.iam_role_arn

  stage {
    name = "Source"

    action {
      category = "Source"
      name     = "Source"
      owner    = "ThirdParty"
      provider = "GitHub"
      version  = 1
      output_artifacts = ["Source"]

      configuration = {
        Owner = "ksm1132"
        Repo = "terraform_web"
        Branch = "master"
        PollForSourceChanges = false
        OAuthToken           = var.github_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      name     = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = 1
      input_artifacts = ["Source"]
      output_artifacts = ["Build"]

      configuration = {
        ProjectName = aws_codebuild_project.example.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      name     = "Deploy"
      owner    = "AWS"
      provider = "ECS"
      version  = 1
      input_artifacts = ["Build"]

      configuration = {
        ClusterName = aws_ecs_cluster.example.name
        ServiceName = aws_ecs_service.example.name
        FileName = "imagedefinitions.json"
      }
    }
  }

  artifact_store {
    location = aws_s3_bucket.artifact.id
    type     = "S3"
  }
}

resource "aws_codepipeline_webhook" "example" {
  authentication  = "GITHUB_HMAC"
  name            = "example"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.example.name

  authentication_configuration {
    secret_token = "VeryRandomStringMoreThan20Byte!"
  }

  filter {
    json_path    = "$.rel"
    match_equals = "refs/heads/{Branch}"
  }
}

