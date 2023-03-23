resource "aws_security_group" "eks-cicd-sg" {
  description = "eks-cicd all"
  vpc_id      = "${data.terraform_remote_state.infra.outputs.vpc_id}"
  tags = {
    "Name"     = "eks-cicd-all"
    "workshop" = "eks-cicd"
  }
}


resource "aws_security_group_rule" "eks-all-cicd" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  # cidr_blocks       = [data.aws_vpc.vpc-cicd.cidr_block]
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.eks-cicd-sg.id
}

resource "aws_security_group_rule" "eks-all-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.eks-cicd-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}