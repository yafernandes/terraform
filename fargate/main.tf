provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "/Users/alex.fernandes/.aws/credentials"
  profile                 = "default"
}

resource "aws_cloudwatch_log_group" "apm-demo" {
  name = "/ecs/fargate-task-definition/${var.name}"

  tags = {
    Creator = "alex.fernandes"
  }
}

resource "aws_ecs_task_definition" "apm_demo" {
  family                   = "apm_sandbox"
  container_definitions    = "${templatefile("apm_demo.json", { dd_api_key = "${var.dd_api_key}", region = "${var.region}", name = "${var.name}" })}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "arn:aws:iam::601427279990:role/ecsTaskExecutionRole"
}

resource "aws_ecs_cluster" "apm_demo" {
  name = "apm_demo"
}

resource "aws_ecs_service" "apm_demo" {
  name            = "apm_demo"
  cluster         = "${aws_ecs_cluster.apm_demo.id}"
  task_definition = "${aws_ecs_task_definition.apm_demo.arn}"
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = ["${aws_subnet.main.id}", "${aws_subnet.backup.id}"]
    security_groups  = ["${aws_security_group.main.id}"]
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.apm_demo.arn}"
    container_name   = "apm-demo"
    container_port   = 8080
  }

  depends_on = [
    "aws_lb_listener.apm_demo"
  ]
}
