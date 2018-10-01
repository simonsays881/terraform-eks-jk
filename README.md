# Terraform with EKS and Jenkins
## Overview

This repo uses terraform to provision an AWS EKS managed kubernetes cluster following this [tutorial](https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html)

**TL;DR:Terraform and EKS on AWS**

1. Set up your IAM profile to be able to do kubernetes things.
2. Build the infrastructure (don't forget to create and switch to a new
   workspace)
3. configure the new cluster with vars.

**TODO: TL;DR:Deploy Jenkins onto EKS**

1. TODO: Set up Jenkins IAM
2. TODO: Set up Jenkins Master
3. TODO: Set up Jenkins Executors

#### Command Line Tools

* [AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

* [kubectl](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

* [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html)

* [helm](https://docs.helm.sh/using_helm/#installing-helm)

##### aws-iam-authenticator

* download authenticator via curl
* make executable
* mv to classpath (cp aws-iam-authenticator /usr/local/sbin)

```
aws —version #need version 1.16.8+
aws sts get-caller-identity #uses this IAM profile for kubectl execution
```

##### Deploying Jenkins

1. Define jenkins.yaml
2. Create a jenkins pod
3. Run the image as a container
4. Get password


```
kubectl create pod -f pods/jenkins.yaml
kubectl run [pod-name]
kubectl port-forward [pod-name] --port 8080:8080
kubectl exec [pod-name] -- cat /var/jenkins_home/secrets/initialAdminPassword
kubectl describe deployments | pods | services
```


Stop the pod

##### helm & tiller 

Helm is a package manager for your kubernetes cluster and is used with Tiller, the cluster-side agent.

It is available via homebrew or via source / curl


If you see an error message like this one:

`Error: release jenkins_v1 failed: namespaces "default" is forbidden: User "system:serviceaccount:kube-system:default" cannot get namespaces in the namespace "default"`

Follow this doc to resolve

https://docs.helm.sh/using_helm/#tiller-and-role-based-access-control



#### Terraform AWS Architecture

Before building the infrastructure, remember to create and use a workspace

##### Networking
- vpc
- 2 subnets
- route table
- 2 route table association (one per subnet)

##### EKS Master

- eks cluster 
- iam role
- 2 iam role policy attachments (EKSCluster / EKSService Policy)
- security group
- security group rule (local workstation to master)


##### EKS Workers

- security group
- security group rule (node to self)
- security group rule (master to node)
- security group rule (node to master via https)
- iam role
- iam instance profile
- 3 iam policy documents (EKSWorker / CNI / EC2ContainerRegistryRO)
- eks 

##### Autoscaling Group / Config

- autoscaling group
- asg launch configuration
- amazon ami for kubernetes
- userdata

##### Cluster & Worker Config

- kube_config
- config_map_aws_auth

#### Configure local workstation with kube_config

* Apply eks config
* Apply worker nodes config

```
terraform output kube_config > ~/.kube/config
terraform output config_map_aws_auth > config_map_aws_auth.yaml
kubectl apply -f config_map_aws_auth.yaml
kubectl get nodes —watch
```

You should see output similiar to the following:

```
terraform-eks-jk master % ./bin/connect_kubectl
Configuring EKS cluster
Configuring EKS worker nodes
configmap/aws-auth created
NAME                        STATUS     ROLES     AGE       VERSION
ip-10-0-0-32.ec2.internal   NotReady   <none>    1s        v1.10.3
ip-10-0-0-32.ec2.internal   NotReady   <none>    1s        v1.10.3
ip-10-0-1-235.ec2.internal   NotReady   <none>    1s        v1.10.3
ip-10-0-1-235.ec2.internal   NotReady   <none>    1s        v1.10.3
```

