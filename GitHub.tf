provider "github" {
  owner = "ksm1132"
}

resource "github_repository_webhook" "example" {
  events = ["push"]
  repository = "terraform_web"
  configuration {
    url = aws_codepipeline_webhook.example.url
    secret = "VeryRandomStringMoreThan20Byte!"
    content_type = "json"
    insecure_ssl = false
  }
}