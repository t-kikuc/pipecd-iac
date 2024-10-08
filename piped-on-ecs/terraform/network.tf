resource "aws_security_group" "piped_sg" {
  name        = "piped-${var.suffix}"
  description = "Security group for Piped. No Ingress is required."
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4" {
  security_group_id = aws_security_group.piped_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}