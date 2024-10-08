resource "aws_ecs_task_definition" "example_batch" {
  container_definitions = file("./batch_container_definitions.json")
  family                = "example-batch"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
}