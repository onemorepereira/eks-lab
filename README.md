# Kubernetes in AWS using KubeCtl

## Creating a cluster

### Using eksctl

```bash
eksctl create cluster -f cluster.yaml
```

## AWS ALB Ingress Controller

_Read more about the AWS ALB Ingress Controller over [here](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/controller/setup/)._

### Installation

#### Before you get started

```bash
# Download the RBAC role manifest
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.3/docs/examples/rbac-role.yaml
# Install the RBAC role manifest
kubectl apply -f rbac-role.yaml
# Download the ALB ingress controller manifest
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.3/docs/examples/alb-ingress-controller.yaml
```

#### Install the controller

At a minimum, you'll need to customize the `--cluster-name=` value on `alb-ingress-controller.yaml` to match the cluster's name. Then you can apply the manifest to your cluster.

```bash
# Install the ALB ingress controller
kubectl apply -f alb-ingress-controller.yaml
```

#### Check the controller

```bash
# Check the controller is running
kubectl logs -n kube-system $(kubectl get po -n kube-system | egrep -o "alb-ingress[a-zA-Z0-9-]+")
```

You should see something like this

```text
-------------------------------------------------------------------------------
AWS ALB Ingress controller
  Release:    v1.1.3
  Build:      git-6101b02d
  Repository: https://github.com/kubernetes-sigs/aws-alb-ingress-controller.git
-------------------------------------------------------------------------------
```

### Cluster Observability

***Retrieve the `admin-user` token***

```bash
kubectl describe secret \
  $(kubectl get secrets \
    -n kubernetes-dashboard \
    |grep admin-user-token \
    |awk '{print $1}') \
  -n kubernetes-dashboard
```

***Accessing Dashboards***

Proxy the cluster control plane

```bash
kubect proxy
```

***URL***

> http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/