# Terraform with EKS and Jenkins
## Overview

This repo uses terraform to provision an AWS EKS managed kubernetes cluster following this [tutorial](https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html)

**TL;DR:Terraform and EKS on AWS**

1. Set up your IAM profile to be able to do kubernetes things.
2. Build the infrastructure
3. configure the new cluster with vars.

**TODO: TL;DR:Deploy Jenkins onto EKS**

1. TODO: Set up Jenkins IAM
2. TODO: Set up Jenkins Master
3. TODO: Set up Jenkins Executors

#### Command Line Tools

[AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
[kubectl](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)
[aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html)

##### aws-iam-authenticator

* download authenticator via curl
* make executable
* mv to classpath (cp aws-iam-authenticator /usr/local/sbin)

```
aws —version #need version 1.16.8+
aws sts get-caller-identity #uses this IAM profile for kubectl exec
```

#### Terraform AWS Architecture

##### Networking
- vpc
- 2 subnets
- route table
- route table association

##### EKS Master

- security group
- security group rule (local workstation to master)
- iam role
- iam policy documents
- eks master


##### EKS Workers

- security group
- security group rule (node to node)
- security group rule (node to master)
- security group rule (master to node)
- iam role
- iam policy documents
- eks master

##### Autoscaling Group / Config

- autoscaling group
- asg launch configuration
- amazon ami for kubernetes

#### Configure local workstation with kube_config

* Apply eks config
* Apply worker nodes config

```
terraform output kube_config > ~/.kube/config
terraform output config_map_aws_auth > config_map_aws_auth.yaml
kubectl apply -f config_map_aws_auth.yaml
kubectl get nodes —watch
```

##### Verify Architecture
