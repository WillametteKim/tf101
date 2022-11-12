resource "aws_security_group" "this" {
  name        = "${var.environment}-${var.app_name}-redis-sg"
  description = "Allow to List"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment}-${var.app_name}-redis-sg"
    }
  )
}

resource "aws_security_group_rule" "inbound_allow_all" {
  type              = "ingress"
  security_group_id = aws_security_group.this.id

  from_port   = var.port
  to_port     = var.port
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.selected.cidr_block] # Hint: use concat() if necessary, concat(["MYIP/32"], ["VPCCIDR/mask"])
  description = "Inbound Allow List"
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type              = "egress"
  security_group_id = aws_security_group.this.id

  from_port   = "-1"
  to_port     = "-1"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Outbound Allow All"
}
