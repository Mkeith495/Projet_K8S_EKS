# Projet Kubernetes AWS (EKS) — Gestion Produits

Ce dépôt contient :

- l’infrastructure AWS (Terraform) pour déployer un cluster **EKS** et les briques associées (VPC, EFS, ECR, AWS Load Balancer Controller, etc.)
- l’application **gestion-produits** et ses manifests Kubernetes (environnements `dev` et `prod`)

## 1) Points d’entrée (où aller en premier)

- Infra AWS (Terraform) :
  - `INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws/README.md`
- Application :
  - `CONTENEURISATION_DOCKER_&_KUBERNETES/gestion-produits/README.md`
- Manifests Kubernetes :
  - `CONTENEURISATION_DOCKER_&_KUBERNETES/gestion-produits/k8s/dev.yaml`
  - `CONTENEURISATION_DOCKER_&_KUBERNETES/gestion-produits/k8s/prod.yaml`

## 2) Déployer l’infrastructure AWS (Terraform)

Aller dans :

- `INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws/`

Puis :

```bash
terraform init
terraform plan
terraform apply
```

Configurer kubectl :

```bash
aws eks update-kubeconfig --region eu-west-3 --name mspk-eks
kubectl get nodes -o wide
```

## 3) Déployer l’application sur Kubernetes (dev + prod)

Appliquer les manifests :

```bash
kubectl apply -f "CONTENEURISATION_DOCKER_&_KUBERNETES/gestion-produits/k8s/dev.yaml"
kubectl apply -f "CONTENEURISATION_DOCKER_&_KUBERNETES/gestion-produits/k8s/prod.yaml"
```

## 4) Vérifications / preuves

Vérifier pods + services :

```bash
kubectl -n gp-dev get pods,svc
kubectl -n gp-prod get pods,svc
```

Vérifier l’Ingress (ALB) et récupérer le DNS :

```bash
kubectl -n gp-dev get ingress
kubectl -n gp-prod get ingress
```

Tester l’accès HTTP via le DNS de l’ALB :

```bash
curl -I http://<ALB_DNS_DEV>
curl -I http://<ALB_DNS_PROD>
```

Les sorties complètes (preuves + historique) sont dans :

- `INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws/README.md` (section "Validation finale (preuves)")
