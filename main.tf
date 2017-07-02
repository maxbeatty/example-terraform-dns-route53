provider "aws" {
  region = "us-east-1"
}

variable "ttl" {
  default = "3600"
}

resource "aws_route53_zone" "example" {
  name = "example.domain"
}

resource "aws_route53_record" "example_mx" {
  zone_id = "${aws_route53_zone.example.zone_id}"
  name    = ""
  type    = "MX"

  records = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ASPMX2.GOOGLEMAIL.COM",
    "10 ASPMX3.GOOGLEMAIL.COM",
  ]

  ttl = "${var.ttl}"
}

variable "example_gsuite" {
  default = ["mail", "cal", "docs"]
}

resource "aws_route53_record" "example_gsuite" {
  count   = "${length(var.example_gsuite)}"
  zone_id = "${aws_route53_zone.example.zone_id}"
  name    = "${element(var.example_gsuite, count.index)}"
  type    = "CNAME"
  records = ["ghs.google.com"]
  ttl     = "${var.ttl}"
}
