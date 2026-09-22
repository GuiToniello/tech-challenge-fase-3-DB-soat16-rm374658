# Regras como recursos separados (sem blocos inline), para que outros repos,
# como o LAMBDA, possam adicionar suas proprias regras neste SG sem conflito.

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Private PostgreSQL access from EKS nodes"
  vpc_id      = data.aws_vpc.this.id
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks_nodes" {
  security_group_id            = aws_security_group.rds.id
  description                  = "PostgreSQL from EKS nodes"
  referenced_security_group_id = data.aws_security_group.eks_nodes.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "rds_all" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
