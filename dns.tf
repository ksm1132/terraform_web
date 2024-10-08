data "aws_route53_zone" "example" {
  name = "mk3te.wjg.jp"
}


resource "aws_route53_record" "example" {
  name = data.aws_route53_zone.example.name
  type = "A"
  zone_id = data.aws_route53_zone.example.zone_id

  alias {
    name = aws_lb.example.dns_name
    zone_id = aws_lb.example.zone_id
    evaluate_target_health = true
  }
}

output "domain_name" {
  value = aws_route53_record.example.name
}

