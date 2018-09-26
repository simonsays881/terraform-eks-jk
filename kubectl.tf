locals {
  kube_config = <<EOF
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.jk_cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.jk_cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
EOF
}

output "kube_config" {
  value = "${local.kube_config}"
}

locals {
  config_map_aws_auth = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks_node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
EOF
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}
