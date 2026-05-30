# Kubernetes – notes simples + bonnes pratiques (cours)

Ce document explique **terre à terre** ce que tu as fait pour déployer un `nginx` sur le cluster Kubernetes du cours, et les **bonnes pratiques** associées.

> Contexte : tu exécutes `kubectl` **en local (sur ton PC)** et tu parles à un cluster distant (microk8s) via un fichier `kubeconfig`.

---

## 1) Les 3 éléments à retenir

- **`kubectl`** : l’outil en ligne de commande qui envoie des ordres au cluster.
- **`kubeconfig`** (souvent un fichier nommé `config`) : le fichier qui dit à `kubectl` **où est le cluster** et **quels identifiants** utiliser.
- **manifests YAML** : tes fichiers `k8s/*.yml` qui décrivent ce que tu veux créer (Pod, Service…).

---

## 2) Vérifier que `kubectl` parle bien au cluster

### Voir les contextes
```bash
kubectl config get-contexts
```

### Vérifier le cluster
```bash
kubectl cluster-info
```

### Pourquoi `--insecure-skip-tls-verify`
Dans ton cours, on utilise souvent :

```bash
kubectl --insecure-skip-tls-verify ...
```

Ça demande à `kubectl` d’ignorer la vérification TLS. C’est pratique en cours quand le certificat n’est pas reconnu par ta machine.

---

## 3) Organisation recommandée dans le repo

- `k8s/` : tous tes manifests Kubernetes
  - `nginx.yml`
  - `nginx-service.yml`

Bonnes pratiques :
- **Un dossier `k8s/` par projet**.
- **Des noms clairs** (ex: `app-deployment.yml`, `app-service.yml`).
- Si tu as plusieurs environnements (dev/prod), tu peux faire :
  - `k8s/dev/`
  - `k8s/prod/`

---

## 4) Ce que tu as déployé

### 4.1 Pod (nginx)
Un **Pod** = une “instance” de conteneur(s) qui tourne dans le cluster.

Tu as créé un Pod `nginx-mkeith495`.

Commande :
```bash
kubectl --insecure-skip-tls-verify apply -f k8s/nginx.yml
```

Vérification :
```bash
kubectl --insecure-skip-tls-verify get pods
```

Bonnes pratiques :
- Un Pod “nu” est OK pour apprendre, mais en vrai on préfère un **Deployment** (gestion du redémarrage, mise à jour, replicas).

### 4.2 Service (NodePort)
Un **Service** = un point d’accès stable vers un ou plusieurs Pods.

Tu as créé un Service `nginx-mkeith495` en type **NodePort**.

Commande :
```bash
kubectl --insecure-skip-tls-verify apply -f k8s/nginx-service.yml
```

Vérification :
```bash
kubectl --insecure-skip-tls-verify get svc nginx-mkeith495
```

Dans ta sortie, tu as eu :

- `80:30288/TCP`

Ça veut dire :
- le Service écoute sur le port **80** (dans le cluster)
- il expose aussi un port **30288** sur le(s) node(s) Kubernetes

---

## 5) Comment accéder à ton Nginx depuis le navigateur

Avec `NodePort`, l’URL est :

```text
http://<IP_DU_NODE>:<NODEPORT>/
```

Dans ton cas :
- `<NODEPORT>` = `30288`

Il te manque juste `<IP_DU_NODE>` (l’IP de la machine/VM qui héberge le cluster). Selon le cours, c’est :
- soit l’IP du serveur (celle que ton prof donne)
- soit une IP interne si tu es sur VPN

Commande utile pour voir des infos :
```bash
kubectl --insecure-skip-tls-verify get nodes -o wide
```

---

## 6) Les commandes de base à connaître (et à retenir)

### Appliquer (créer / mettre à jour)
```bash
kubectl --insecure-skip-tls-verify apply -f k8s/
```

### Voir l’état
```bash
kubectl --insecure-skip-tls-verify get pods
kubectl --insecure-skip-tls-verify get svc
```

### Comprendre pourquoi ça ne marche pas
```bash
kubectl --insecure-skip-tls-verify describe pod nginx-mkeith495
kubectl --insecure-skip-tls-verify logs nginx-mkeith495
```

### Supprimer ce que tu as créé
```bash
kubectl --insecure-skip-tls-verify delete -f k8s/
```

---

## 7) Bonnes pratiques importantes (version simple)

- **Toujours vérifier ce que tu appliques** :
  - `kubectl apply -f k8s/` applique tout le dossier
- **Toujours vérifier après** :
  - `kubectl get pods` / `kubectl get svc`
- **Garder des labels simples et cohérents** :
  - le `Service` sélectionne les Pods via `spec.selector`
  - donc tes Pods doivent avoir le même label (ex: `app: nginx-mkeith495`)
- **Éviter les erreurs YAML** :
  - indentation + listes avec `-`
  - pas de points en fin de valeur (`NodePort.` = invalide)
- **Ne pas paniquer** :
  - si `kubectl apply` échoue, lis l’erreur, corrige le YAML, et relance `apply`

---

## 8) Suite logique (si le prof demande “mieux”)

1) Remplacer le `Pod` par un **Deployment**
2) Ajouter un **Ingress** (plus propre que NodePort)
3) Ajouter du stockage (PVC) si base de données

---

## Résultat obtenu (ce que tu as validé)

- `pod/nginx-mkeith495` : **Running**
- `service/nginx-mkeith495` : **NodePort** (ex: `30288`)

Tu es donc bien capable de :
- écrire un manifest
- l’appliquer
- vérifier que ça tourne
- obtenir un port d’accès
