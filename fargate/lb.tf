resource "aws_lb" "apm_demo" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.main.id}"]
  subnets            = ["${aws_subnet.main.id}", "${aws_subnet.backup.id}"]

  tags = {
    Creator = "alex.fernandes"
  }
}
resource "aws_lb_target_group" "apm_demo" {
  protocol    = "HTTP"
  port        = 8080
  target_type = "ip"
  vpc_id      = "${aws_vpc.main.id}"
  depends_on  = ["aws_lb.apm_demo"]
  health_check {
    port         = 8080
    path         = "/HappyPath/healthcheck"
    interval     = 60
    timeout      = 45
  }
}

resource "aws_lb_listener" "apm_demo" {
  load_balancer_arn = "${aws_lb.apm_demo.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.apm_demo.arn}"
  }
}

output "lb_dns" {
  value = "${aws_lb.apm_demo.dns_name}"
}
