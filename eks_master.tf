resource "aws_iam_role" "jk_cluster" {
  name = "terraform-eks-jk_cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_jk_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.jk_cluster.name}"
}

resource "aws_iam_role_policy_attachment" "eks_jk_cluster_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.jk_cluster.name}"
}

resource "aws_security_group" "jk_cluster" {
  name        = "terraform-eks-jk-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.eks_jk.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-eks-jk"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "jk_cluster_ingress_local" {
  count             = 1
  cidr_blocks       = ["50.244.31.163/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jk_cluster.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "jk_cluster" {
  name            = "${var.cluster_name}"
  role_arn        = "${aws_iam_role.jk_cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.jk_cluster.id}"]
    subnet_ids         = ["${aws_subnet.eks_jk_subnet.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks_jk_cluster_policy",
    "aws_iam_role_policy_attachment.eks_jk_cluster_service_policy",
  ]
}
