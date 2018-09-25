resource "aws_iam_role" "eks_node" {
  name = "terraform-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_node_Amazon_EKS_Worker_Node_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks_node.name}"
}

resource "aws_iam_role_policy_attachment" "eks_node_Amazon_EKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks_node.name}"
}

resource "aws_iam_role_policy_attachment" "eks_node_Amazon_EC2_Container_Registry_ReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks_node.name}"
}

resource "aws_iam_instance_profile" "eks_node" {
  name = "terraform-eks-demo"
  role = "${aws_iam_role.eks_node.name}"
}

resource "aws_security_group" "eks_node" {
  name        = "terraform-eks-demo-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.eks_jk.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "terraform-eks-demo-node",
     "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  }"
}

resource "aws_security_group_rule" "node_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks_node.id}"
  source_security_group_id = "${aws_security_group.eks_node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_node.id}"
  source_security_group_id = "${aws_security_group.jk_cluster.id}"
  to_port                  = 65535
  type                     = "ingress"

  }

resource "aws_security_group_rule" "cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.jk_cluster.id}"
  source_security_group_id = "${aws_security_group.eks_node.id}"
  to_port                  = 443
  type                     = "ingress"
}