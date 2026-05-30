# Documentation — Mise en place d’un cluster Kubernetes (EKS) + stockage partagé (EFS) sur AWS avec Terraform

Ce document explique, **pas à pas**, comment reproduire l’infrastructure AWS que tu viens de construire :

- Un **cluster Kubernetes EKS**
- Un **Node Group** de **3 nœuds** (EC2)
- Un stockage partagé **EFS** utilisable par Kubernetes
- Le driver **EFS CSI** installé dans le cluster
- Une **StorageClass** Kubernetes `efs-sc`

L’objectif est que **toi plus tard** (ou quelqu’un d’autre) puisse **repartir de zéro** et arriver au même résultat.

---

## 0) Ce que tu obtiens à la fin (résultat attendu)

### Résultat côté AWS
- Un VPC dédié (réseau privé AWS)
- Un cluster EKS nommé `mspk-eks`
- Un Node Group EKS (3 instances EC2)
- Un EFS (filesystem partagé)

### Résultat côté Kubernetes
Les commandes suivantes doivent fonctionner :

```powershell
aws eks update-kubeconfig --region eu-west-3 --name mspk-eks
kubectl get nodes
kubectl get sc
```

Et tu dois voir :
- 3 nœuds en `Ready`
- une StorageClass `efs-sc`

---

## 1) Pré-requis (comprendre les briques)

### 1.1 AWS (comptes et permissions)
Pour que Terraform puisse créer des ressources sur AWS, il faut :
- un **compte AWS**
- un **utilisateur IAM** avec des droits
- une **Access Key** + **Secret Key** configurées localement

> Important : `aws configure` n’utilise pas une “clé au hasard”. Il utilise **exclusivement** une paire **AccessKeyId/SecretAccessKey** IAM.

### 1.2 Outils locaux nécessaires
- **Terraform** (outil IaC)
- **AWS CLI** (outil officiel AWS)
- **kubectl** (client Kubernetes)

---

## 2) Création des identifiants AWS (IAM) — une seule fois

### 2.1 Installer AWS CLI
Vérifier si AWS CLI est installé :

```powershell
aws --version
```

Si non installé :

```powershell
winget install -e --id Amazon.AWSCLI
```

Puis fermer/réouvrir le terminal et vérifier à nouveau `aws --version`.

### 2.2 Créer un utilisateur IAM pour Terraform
Dans la console AWS :
- Aller dans **IAM**
- **Users (Utilisateurs)**
- **Create user** (ex: `terraform-user`)
- Attacher une policy (pour ce projet) : **AdministratorAccess**

> Note : `AdministratorAccess` est large, mais évite des dizaines d’erreurs “AccessDenied” pendant le TP. On pourra restreindre plus tard.

### 2.3 Créer l’Access Key
Toujours dans IAM :
- Utilisateur `terraform-user`
- Onglet **Security credentials**
- Section **Access keys**
- **Create access key**
- Cas d’usage : **CLI**

Copier immédiatement :
- `Access key ID`
- `Secret access key`

### 2.4 Configurer les clés sur le PC

```powershell
aws configure
```

Saisir :
- **AWS Access Key ID** : valeur IAM
- **AWS Secret Access Key** : valeur IAM
- **Default region name** : `eu-west-3`
- **Default output format** : `json`

Vérifier que l’auth fonctionne :

```powershell
aws sts get-caller-identity
```

Si tu reçois un JSON avec `Account` et `Arn`, c’est bon.

---

## 3) Où se trouve le code Terraform AWS dans le repo

Le dossier de travail Terraform AWS est :

`INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws`

Les fichiers principaux :
- `versions.tf` : versions providers
- `providers.tf` : configuration providers AWS/Kubernetes/Helm
- `variables.tf` : variables de base (region, version EKS, type d’instance)
- `vpc.tf` : création VPC + subnets + NAT
- `eks.tf` : création EKS + node group + install helm EFS CSI
- `efs.tf` : création EFS + mount targets
- `k8s-storage.tf` : création StorageClass `efs-sc`
- `outputs.tf` : sorties utiles (cluster_name, storageclass, etc.)

---

## 4) Exécuter Terraform (création infra)

Se placer dans le dossier :

```bash
cd "INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws"
```

Puis :

```bash
terraform init
terraform plan
terraform apply
```

### 4.1 Durée normale
- Un `apply` EKS n’est pas rapide : **10 à 30 minutes** est courant.

> Ce temps n’est pas “Terraform qui bloque”. C’est AWS qui crée VPC/NAT/EKS/NodeGroup.

---

## 5) Explication simple des composants AWS créés

### 5.1 VPC / Subnets / NAT
- **VPC** : ton réseau privé sur AWS (comme un réseau d’entreprise)
- **Subnets publics** : pour les ressources qui ont besoin d’Internet direct
- **Subnets privés** : pour tes nœuds Kubernetes (plus sécurisé)
- **NAT Gateway** : permet aux machines privées de sortir sur Internet (télécharger images Docker, packages)

### 5.2 EKS
EKS = Kubernetes managé.
- AWS gère les composants “control plane” (API server, etcd, etc.)
- Toi tu fournis des machines (Node Group) qui font tourner tes pods

### 5.3 Node Group
Un node group = un groupe de machines EC2 qui rejoignent le cluster.

Dans ce projet : 3 nœuds.

### 5.4 EFS
EFS = un disque réseau partagé.
- Un même filesystem peut être monté depuis plusieurs machines
- C’est ce qui permet des volumes Kubernetes en **RWX** (ReadWriteMany)

---

## 6) Se connecter au cluster (kubectl)

Après un `terraform apply` réussi, récupérer la config kubectl :

```powershell
aws eks update-kubeconfig --region eu-west-3 --name mspk-eks
```

Vérifier :

```powershell
kubectl get nodes
kubectl get sc
```

Attendu :
- 3 nodes en `Ready`
- `efs-sc` visible

### 6.1 Note sur les commandes qui “tournent en boucle” (`-w`)
Certaines commandes kubectl peuvent rester ouvertes si tu ajoutes `-w` (watch). Exemple :

```powershell
kubectl get nodes -w
```

`-w` = affichage en temps réel. La commande ne se termine pas toute seule.

Pour l’arrêter :
- `Ctrl + C`

---

## 7) Pourquoi on a eu des erreurs (et ce que ça veut dire)

Cette section documente les problèmes rencontrés, parce qu’ils sont réalistes et peuvent réapparaître.

### 7.1 Terraform ne télécharge pas les modules (registry timeout)
Erreur type :
- accès à `registry.terraform.io` en timeout

Cause fréquente :
- connexion instable

Action :
- relancer `terraform init -upgrade`

### 7.2 EKS NodeGroup CREATE_FAILED (Free Tier)
Erreur :
- `AsgInstanceLaunchFailures` / “instance type not eligible for Free Tier”

Cause :
- `t3.medium` n’est pas Free Tier

Fix :
- `node_instance_types = ["t3.micro"]` dans `variables.tf`

Note :
- En pratique, `t3.micro` est souvent trop limité pour un cluster EKS + add-ons (CNI/EFS CSI) + applications.
- La configuration finale utilisée ici est `t3.small` pour éviter les blocages de scheduling.

### 7.3 Un pod EFS controller en Pending : “Too many pods”
Erreur `kubectl describe pod` :
- `0/3 nodes are available: 3 Too many pods`

Cause :
- limite max de pods sur petites instances (EKS + VPC CNI)

Fix :
- n’avoir qu’**un seul** replica controller

Commandes (one-shot) :

```powershell
kubectl -n kube-system scale deployment efs-csi-controller --replicas=1
```

Et côté Terraform, le chart Helm est configuré pour `controller.replicaCount = 1`.

### 7.4 Terraform Helm en “system:anonymous”
Erreur :
- `secrets is forbidden: User "system:anonymous" cannot list resource "secrets"`

Cause :
- provider Helm/Kubernetes Terraform non authentifié correctement

Fix :
- providers Terraform configurés avec `exec` utilisant :
  `aws eks get-token --cluster-name ...`

### 7.5 AWS interdit le downgrade (ex: 1.30 -> 1.29)
Erreur :
- `Unsupported Kubernetes minor version update from 1.30 to 1.29`

Cause :
- EKS n’autorise pas de descendre de version

Fix :
- aligner `cluster_version` sur la version réelle du cluster (ici `1.30`)

### 7.6 Ingress ALB en erreur (403 AccessDenied sur AddTags)
Symptôme (`kubectl get events` sur l’Ingress) :
- `AccessDenied: ... is not authorized to perform: elasticloadbalancing:AddTags ...`

Cause :
- policy IAM incomplète pour AWS Load Balancer Controller

Fix :
- mettre à jour la policy utilisée par le rôle IRSA de l’ALB Controller pour autoriser `elasticloadbalancing:AddTags`

### 7.7 Bases de données en Pending (PVC gp2 / EBS CSI manquant)
Symptôme :
- pods `mysql` / `postgres` en `Pending`
- PVC `gp2` en `Pending` avec : `Waiting for a volume to be created either by the external provisioner 'ebs.csi.aws.com'`

Cause :
- add-on `aws-ebs-csi-driver` non installé sur le cluster

Fix :
- installer l’add-on EKS `aws-ebs-csi-driver` + son rôle IRSA (`AmazonEBSCSIDriverPolicy`)

---

## 8) Vérifications finales (checklist)

### 8.1 Kubernetes
- [ ] `kubectl get nodes` -> 3 `Ready`
- [ ] `kubectl get sc` -> `efs-sc` présent

### 8.2 EFS CSI
- [ ] `kubectl -n kube-system get pods | findstr efs` -> pods Running

### 8.3 Preuve de fonctionnement EFS (RWX)
On valide EFS avec :
- un PVC RWX sur la StorageClass `efs-sc`
- un pod qui écrit puis relit un fichier sur `/data`

Le manifest est dans :
- `INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws/k8s/efs-rwx-test.yaml`

Commandes :

```powershell
kubectl create ns storage-test
kubectl apply -f "INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws/k8s/efs-rwx-test.yaml"
kubectl -n storage-test get pvc,pod
```

Lecture du fichier (important si tu utilises Git Bash) :

```bash
kubectl -n storage-test exec efs-tester -- sh -c "ls -l /data && cat /data/hello.txt"
```

Pourquoi `sh -c` ?
- Git Bash peut convertir `/data/...` en chemin Windows (ex: `C:/Program Files/Git/...`).
- `sh -c` force l’interprétation de `/data/...` dans le conteneur.

### 8.4 AWS Load Balancer Controller (ALB) (Ingress)
Le contrôleur ALB a été installé via Terraform (Helm) pour gérer les `Ingress` sur AWS.

Vérification :

```powershell
kubectl -n kube-system get pods | findstr load-balancer
```

Attendu :
- 1 ou 2 pods `aws-load-balancer-controller` en `Running`

### 8.5 ECR (registry des images Docker)
On utilise ECR pour publier l’image Docker de l’application.

Après `terraform apply`, on récupère l’URL du repo :

```powershell
terraform output ecr_repository_url
```

Puis on pousse l’image :

```powershell
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 270269786227.dkr.ecr.eu-west-3.amazonaws.com
docker push 270269786227.dkr.ecr.eu-west-3.amazonaws.com/gestion-produits:latest
```

---

## 9) Validation finale (preuves)

Sorties Terraform :

```bash
terraform output

Nœuds Kubernetes : 
kubectl get nodes -o wide


Déploiement dev :
kubectl -n gp-dev get pods,svc,ingress


Déploiement dev :
kubectl -n gp-dev get pods,svc,ingress


Tests HTTP (ALB) :
curl -I http://k8s-gpdev-gpdev-c8787c21e4-458106294.eu-west-3.elb.amazonaws.com

curl -I http://k8s-gpprod-gpprod-2f70fe8de1-81783359.eu-west-3.elb.amazonaws.com





TEST PREUVES :

jouvence computer@PC-Maxence-keith MINGW64 ~/Documents/IaC_&_KUBERNETES/INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws (main)
$ nslookup k8s-gpdev-gpdev-c8787c21e4-458106294.eu-west-3.elb.amazonaws.com
nslookup k8s-gpprod-gpprod-2f70fe8de1-81783359.eu-west-3.elb.amazonaws.com
Serveur :   UnKnown
Address:  192.168.37.162

R�ponse ne faisant pas autorit� :
Nom :    k8s-gpdev-gpdev-c8787c21e4-458106294.eu-west-3.elb.amazonaws.com
Addresses:  13.37.200.29
          13.38.210.72
          15.236.229.49

Serveur :   UnKnown
Address:  192.168.37.162

R�ponse ne faisant pas autorit� :
Nom :    k8s-gpprod-gpprod-2f70fe8de1-81783359.eu-west-3.elb.amazonaws.com
Addresses:  52.47.118.245
          52.47.159.175
          13.37.47.241


jouvence computer@PC-Maxence-keith MINGW64 ~/Documents/IaC_&_KUBERNETES/INFRASTRUCTURE_AS_CODE/Partage/ressources/env-aws (main)
$ curl -I http://k8s-gpdev-gpdev-c8787c21e4-458106294.eu-west-3.elb.amazonaws.com
curl -I http://k8s-gpprod-gpprod-2f70fe8de1-81783359.eu-west-3.elb.amazonaws.com
HTTP/1.1 200 OK
Date: Fri, 29 May 2026 13:14:37 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
Server: Apache/2.4.67 (Debian)
X-Powered-By: PHP/8.2.31

HTTP/1.1 200 OK
Date: Fri, 29 May 2026 13:14:37 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
Server: Apache/2.4.67 (Debian)
X-Powered-By: PHP/8.2.31
