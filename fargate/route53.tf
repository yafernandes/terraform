data "aws_route53_zone" "pipsquack" {
  name = "aws.pipsquack.ca"
}

resource "aws_route53_record" "master" {
  zone_id = "${data.aws_route53_zone.pipsquack.zone_id}"
  name    = "apm.fargate"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.apm_demo.dns_name}"]
}
