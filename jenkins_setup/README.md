# Jenkins with Containers (Kubernetes and Docker)

## TL;DR

Launch a container running master :

`docker run -p 8080:8080 jenkins/jenkins:lts`

Attach executors to the master

`Dockerfile from scratch setting up agents and connecting to master`

[Source Dockerfile](https://github.com/jenkinsci/docker) for more information on how to configure this container

## Setup Master 

Run the master

* Navigate to the main page, then click: *Manage Jenkins -> Manage Nodes and then click New Node*

## Tutorials

### Kubernetes with Jenkins

[Kubernetes - Tutorial 1](https://dzone.com/articles/how-to-setup-scalable-jenkins-on-top-of-a-kubernet)

[Kubernetes - Tutorial 2](https://devopscube.com/setup-jenkins-on-kubernetes-cluster/)

### Jenkins with Docker 

[Tutorial 1](https://devopscube.com/jenkins-master-build-slaves-docker-container/)

[Ephemeral Docker Containers](https://engineering.riotgames.com/news/jenkins-ephemeral-docker-tutorial)

[Configuration as Code w/ Vault](https://piotrminkowski.wordpress.com/2018/09/24/running-jenkins-server-with-configuration-as-code/)

### CD with Microservices

[CD with Microservices](https://piotrminkowski.wordpress.com/2017/03/20/microservices-continuous-delivery-with-docker-and-jenkins/)

[Microservices Repo](https://github.com/piomin/sample-spring-microservices) (to be used with above tutorial) 
