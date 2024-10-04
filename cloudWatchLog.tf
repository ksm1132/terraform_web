
resource "aws_cloudwatch_log_group" "for_ecs" {
  name = "/ecs/example"
  retention_in_days = 180
}

resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
  name = "/ecs-scheduled-tasks/example"
  retention_in_days = 180
}

resource "aws_cloudwatch_event_rule" "example_batch" {
  name = "example-batch"
  description = "とても重要なバッチです"
  schedule_expression = "cron(*/2 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "example_batch" {
  arn  = aws_ecs_cluster.example.arn
  rule = aws_cloudwatch_event_rule.example_batch.name
  target_id = "example-batch"
  role_arn = module.ecs_events_role.iam_role_arn

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.example_batch.arn
    launch_type = "FARGATE"
    task_count = 1
    platform_version = "1.3.0"

    network_configuration {
      subnets = [aws_subnet.private_0.id]
      assign_public_ip = false
    }
  }
}