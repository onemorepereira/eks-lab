# Kubernetes in AWS using KubeCtl

## Requisites

- Install [eksctl](https://eksctl.io/)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Configured AWS profile

---

## Creating the cluster

### (1) Using eksctl

This will deploy a cluster named `eks-lab` under your AWS account.

```bash
eksctl create cluster -f cluster.yaml
```

---

## (2) Deploying K8s components

```bash
./deploy-addons.sh
```

### Add-Ons included on this project

- [AWS ALB Ingress Controller RBAC Role](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/controller/setup/#installation)
  - `./add-ons/00-rbac/01-rbac-role.yaml`
- [AWS ALB Ingress Controller](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/controller/setup/#installation)
  - `./add-ons/10-ingress/alb-ingress-controller.yaml`
- [Metrics Server](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/)
  - `./add-ons/20-metrics-server/aggregated-metrics-reader.yaml`
  - `./add-ons/20-metrics-server/auth-delegator.yaml`
  - `./add-ons/20-metrics-server/aut-reader.yaml`
  - `./add-ons/20-metrics-server/metrics-apiservice.yaml`
  - `./add-ons/20-metrics-server/metrics-server-deployment.yaml`
  - `./add-ons/20-metrics-server/metrics-server-service.yaml`
  - `./add-ons/20-metrics-server/resource-reader.yaml`
- [K8s Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
  - `./add-ons/30-dahboard/31-service-account.yaml`
  - `./add-ons/30-dahboard/32-dashboard.yaml`

## (3) Deploying the examples

```bash
./deploy-examples.sh
```

## (4) Destruction and cleanup

```bash
./destroy.sh
eksctl delete cluster -f cluster.yaml
```

---
> What follows  is nothing more than an unsorted, uncollated, and disparate collection of links to reading material that pertains to the different areas covered by this lab that have yet to be distilled into coherent ideas and given proper structure.

## Further reading

### AWS ALB Ingress Controller

_Read more about the AWS ALB Ingress Controller over [here](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/controller/setup/)._

#### Installation

##### Before you get started

```bash
# Download the RBAC role manifest
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.3/docs/examples/rbac-role.yaml
# Install the RBAC role manifest
kubectl apply -f rbac-role.yaml
# Download the ALB ingress controller manifest
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.3/docs/examples/alb-ingress-controller.yaml
```

##### Install the controller

At a minimum, you'll need to customize the `--cluster-name=` value on `alb-ingress-controller.yaml` to match the cluster's name. Then you can apply the manifest to your cluster.

```bash
# Install the ALB ingress controller
kubectl apply -f alb-ingress-controller.yaml
```

##### Check the controller

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

#### Cluster Observability

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