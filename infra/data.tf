# Rede criada pelo repo K8S (VPC, subnets e SG dos nodes).
# Os recursos sao encontrados pelo cluster EKS e por tag/nome, sem ler o state
# remoto do K8S. A VPC vem do cluster (unico) porque a tag Project pode casar
# com VPCs orfas de applies anteriores.

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_vpc" "this" {
  id = data.aws_eks_cluster.this.vpc_config[0].vpc_id
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-private-*"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_security_group" "eks_nodes" {
  vpc_id = data.aws_vpc.this.id
  name   = "${var.project_name}-nodes-sg"
}
