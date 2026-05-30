# Support de cours (débutant) — Terraform / OpenToFu + Proxmox

Ce document est ton **support de cours** pour rattraper rapidement le chapitre **Infrastructure as Code (IaC) avec Terraform**.

Il est construit à partir de TON workspace (dossier `Partage`) :
- `1 - Notes de cours.md`
- `2 - Exercices - Terraform.md`
- `4 - Accès Proxmox Form.md`
- `Partage/ressources/*` (des fichiers Terraform déjà prêts)

---

## 0) L’idée générale (en mots simples)

### C’est quoi l’Infrastructure as Code (IaC) ?

Au lieu de créer des machines virtuelles “à la main” en cliquant dans une interface, on écrit un **fichier texte** qui décrit ce qu’on veut :
- une VM
- un container
- un réseau
- etc.

Ensuite un outil lit ce fichier et fait le travail pour nous.

### Terraform, ça sert à quoi ?

**Terraform** est un outil IaC.
- Tu écris des fichiers `.tf`.
- Terraform se connecte à une plateforme (Cloud, Proxmox, etc.) avec un **provider**.
- Il crée/modifie/supprime les ressources pour que la réalité corresponde à ce que tu as écrit.

### OpenToFu, c’est quoi ?

**OpenToFu** (“tofu”) est un **fork libre** de Terraform.
Dans beaucoup de cas, il s’utilise pareil.

---

## 1) Terraform vs Ansible (question d’exercice)

Terraform et Ansible sont souvent comparés, mais ils sont surtout **complémentaires**.

### Différence simple

- **Terraform** : crée l’infrastructure (VM, container, disque…).
- **Ansible** : configure ce qu’il y a *dans* les machines (installer nginx, configurer SSH, créer des utilisateurs…).

### Exemple de scénario (réponse exercice)

1. Terraform crée 2 VM (web + base de données).
2. Terraform te donne leurs IP.
3. Ansible se connecte en SSH sur ces IP.
4. Ansible installe les paquets et configure les services.

---

## 2) Tes exercices (ce qu’on te demande réellement)

Le fichier `2 - Exercices - Terraform.md` demande :

### 2.1 Installation
- Installer Terraform et vérifier avec :

```powershell
terraform version
```

- Installer OpenToFu et vérifier avec :

```powershell
tofu version
```

### 2.2 Premiers déploiements sur Proxmox
- Avoir un Proxmox accessible.
- Télécharger le template LXC AlmaLinux 10.
- Déployer un container `alma1` avec Terraform.
- Créer un template VM Ubuntu 24.04, puis cloner `ubuntu-vm-01`.
- Ensuite faire mieux avec des images Cloud + `cloud-init`.

---

## 3) Ton workspace contient déjà une “base Terraform” prête

Dans `Partage/ressources/`, tu as déjà des fichiers Terraform :

- `provider.tf` : dit à Terraform quel provider utiliser (ici Proxmox)
- `variables.tf` : liste les variables (url proxmox, user, password, IP, etc.)
- `ct.tf` : décrit un **container LXC** Proxmox
- `vm.tf` : décrit une **VM** Proxmox
- `proxmox-form.auto.tfvars` : variables pour le **Proxmox de formation**
- `proxmox-local.tfvars` : variables pour un Proxmox local

Donc ton objectif n’est pas de tout inventer : tu dois surtout comprendre :
- comment on lance Terraform
- comment on adapte les variables
- comment on vérifie ce que Terraform va faire

---

## 4) Les commandes Terraform indispensables (à connaître par cœur)

Dans le dossier `Partage/ressources/` :

### 4.1 Initialiser le projet
Télécharge le provider et prépare le dossier `.terraform/`.

```powershell
terraform init
```

### 4.2 Vérifier que le code est correct

```powershell
terraform validate
```

### 4.3 Voir ce qui va être créé (sans rien créer)

```powershell
terraform plan
```

### 4.4 Appliquer (créer/modifier)

```powershell
terraform apply
```

### 4.5 Détruire (supprimer ce qui a été créé)

```powershell
terraform destroy
```

---

## 5) Explication importante : le fichier d’état (`terraform.tfstate`)

Tu as dans `Partage/ressources/` :
- `terraform.tfstate`
- `terraform.tfstate.backup`

Terraform garde un fichier “mémoire” (state) qui lui dit :
- ce qui a été créé
- avec quels identifiants
- et comment suivre/modifier/détruire ces ressources

À retenir :
- si tu perds le state, Terraform “oublie” ce qu’il a créé
- en équipe on met souvent le state dans un stockage distant (GitLab, S3, etc.)

---

## 6) Sécurité (très important)

Tu as des fichiers `.tfvars` qui contiennent des identifiants.
Règles simples :
- ne poste pas ces fichiers sur internet
- idéalement, ne mets pas de mot de passe en clair dans Git
- préfère les **API tokens** et/ou des variables d’environnement

---

## 7) Proxmox “Formation” : ce que tu as

Dans `4 - Accès Proxmox Form.md` tu as :
- une URL Proxmox
- un login
- un mot de passe
- et des infos qui ressemblent à un token

Et dans `proxmox-form.auto.tfvars`, Terraform est déjà configuré pour pointer vers le Proxmox de formation.

**Bonne nouvelle** : tu n’as (probablement) pas besoin d’installer Proxmox localement pour démarrer.

---

## 8) Comment faire l’exercice rapidement avec TON projet (mode “48h”)

### Étape A — Vérifier que Terraform est installé

```powershell
terraform version
```

### Étape B — Aller dans le bon dossier
Tu dois exécuter Terraform dans :

- `Partage/ressources/`

### Étape C — Initialiser et plan

```powershell
terraform init
terraform plan
```

### Étape D — Appliquer

```powershell
terraform apply
```

Si tout est bon, tu devrais voir apparaître les ressources sur Proxmox.

### Étape E — Nettoyer

```powershell
terraform destroy
```

---

## 9) Ton problème de partition D: (pourquoi ça peut casser)

Quand `D:` a été supprimée, il peut rester des chemins cassés dans Windows.
Ça peut provoquer :
- `terraform` introuvable
- `tofu` introuvable
- ssh/ansible qui ne trouvent pas leurs clés

### Vérif rapide : est-ce que ton PATH contient encore D: ?

```powershell
echo $env:Path
```

Si tu vois `D:\...`, dis-le moi.

---

## 10) Ce que tu dois me répondre pour que je t’accompagne exactement

Copie/colle ici les sorties :

1. `terraform version`
2. `tofu version`
3. Dans Proxmox (interface web) : quel est le **nom exact du node** ?
   - (normalement `proxmox-form`, mais je veux confirmer)

Ensuite je te guide pas à pas pour :
- faire fonctionner `terraform init/plan/apply`
- comprendre `provider`, `variables`, `resources`
- valider que tu as réussi l’exercice

---

## Journal détaillé du projet (ce qu’on a fait exactement, avec les difficultés)

Ce chapitre n’est pas un cours “général”. C’est un **journal de ce qu’on a réellement fait** pendant le projet, dans l’ordre, avec les erreurs rencontrées et les décisions prises. L’objectif est que tu puisses le relire plus tard et te dire :

- “ah oui, à ce moment-là c’était ce problème”
- “voilà pourquoi on a changé ça”
- “voilà ce qui marche sur mon PC et ce qui ne marche pas”

### 1) Objectif initial

Tu devais faire fonctionner Terraform (ou OpenToFu) avec Proxmox pour les exercices du cours :

- déployer un conteneur LXC
- déployer une VM (cloud-image qcow2)

Tu n’avais pas d’expérience Proxmox et tu voulais une méthode efficace, sans te perdre.

### 2) Choix de l’environnement Proxmox (remote vs local)

Au départ, on avait des informations d’accès à un Proxmox “formation” (remote) et un fichier de variables déjà prêt :

- `Partage/ressources/proxmox-form.auto.tfvars`

On a ensuite décidé de basculer sur un Proxmox local dans VirtualBox pour être autonome (pas dépendre d’un serveur externe et de ses credentials).

### 3) Mise en place Proxmox local dans VirtualBox (Windows)

Contexte : Proxmox tourne dans une VM VirtualBox sur Windows.

Difficulté rencontrée : conflit fréquent entre VirtualBox et les fonctionnalités d’hyperviseur Windows (Hyper-V / VBS / etc.).

Ce point a été une source importante de pertes de temps, car certains réglages Windows demandent des redémarrages.

### 4) Accès à l’interface web Proxmox (NAT + port forwarding)

Pour accéder à Proxmox depuis Windows, on est passé par une configuration VirtualBox de type **NAT + redirection de port**.

Résultat fonctionnel :

- accès web via `https://127.0.0.1:18006/`

(c’est une redirection du port 18006 de ton Windows vers le port 8006 de Proxmox dans la VM).

### 5) Comprendre les fichiers Terraform du workspace

Dans `Partage/ressources/` tu avais déjà une base Terraform :

- `provider.tf` : provider `bpg/proxmox`
- `variables.tf` : variables (endpoint, username, password, node_name, IP, etc.)
- `ct.tf` : ressource conteneur LXC
- `vm.tf` : ressource VM
- `proxmox-form.auto.tfvars` : variables pour Proxmox formation
- `proxmox-local.tfvars` : variables pour Proxmox local

### 6) Problème d’authentification (HTTP 401 “no such user epsi-m2dev@pve”)

Symptôme :

- Terraform renvoyait `HTTP 401` et disait “no such user ('epsi-m2dev@pve')” alors qu’on voulait se connecter à ton Proxmox local.

Cause :

- `proxmox-form.auto.tfvars` est un fichier `.auto.tfvars` et Terraform le charge automatiquement.
- Même en lançant `terraform ... -var-file=proxmox-local.tfvars`, le `.auto.tfvars` peut injecter des valeurs inattendues.

Résolution :

- On a renommé le fichier auto (pour qu’il ne soit plus auto-chargé) :
  - `proxmox-form.auto.tfvars` → `proxmox-form.auto.tfvars.off`

Et on a verrouillé le fait que sur le local, on n’utilise pas de token :

- ajout de `proxmox_api_token = ""` dans `proxmox-local.tfvars`

Résultat :

- Terraform se connecte bien au Proxmox local avec `root@pam` + mot de passe.

### 7) Pré-requis Proxmox côté images (template LXC + qcow2)

Pour que Terraform puisse créer des ressources, Proxmox doit avoir :

- un template LXC Debian (fichier `.tar.zst`)
- une image VM `.qcow2` importée

Gros blocage initial : l’image `.qcow2` n’était pas disponible.

Résolution :

- import de `debian-13-generic-amd64.qcow2` dans le stockage Proxmox (dans la section “Importer”).

### 8) Déploiement Terraform : le conteneur (OK)

Quand l’authentification et les templates étaient OK, `terraform apply -var-file=proxmox-local.tfvars` a pu créer le conteneur LXC.

Résultat visible :

- conteneur créé avec `id=100`.

### 9) Déploiement Terraform : la VM (bloquée par KVM / nested)

Symptôme :

- Terraform lançait la création de la VM, mais l’étape de démarrage échouait avec un message du type :
  - `KVM virtualisation configured, but not available...`

Cause :

- Proxmox veut utiliser KVM (virtualisation matérielle) pour démarrer une VM.
- Comme Proxmox est lui-même dans VirtualBox, il faudrait la **virtualisation imbriquée** (Nested VT-x/AMD-V).
- Sur ta machine, l’option “Nested VT-x/AMD-V” est restée grisée/non disponible.

Conclusion :

- sur ce poste + VirtualBox, faire tourner des **VM Proxmox** est (dans ton cas) trop instable/chronophage.
- les **conteneurs LXC** fonctionnent, donc on avance avec ça.

### 10) Décision : continuer le cours en LXC uniquement (désactivation de la VM)

Action concrète (dans `vm.tf`) :

- ajout de `count = 0` sur la ressource `proxmox_virtual_environment_vm` pour la désactiver.

Effet :

- Terraform n’essaie plus de créer/démarrer la VM.

### 11) Nettoyage du state Terraform (suppression de la VM 101)

Comme une VM avait déjà été créée (`id=101`) avant la désactivation, Terraform a ensuite proposé de la détruire :

- `Plan: 0 to add, 0 to change, 1 to destroy` (la VM)

Action :

- on a fait `terraform apply -var-file=proxmox-local.tfvars` et validé `yes`.

Résultat :

- VM `101` détruite proprement.

### 12) Validation : infrastructure stable

Commande :

- `terraform plan -var-file=proxmox-local.tfvars`

Résultat :

- `No changes. Your infrastructure matches the configuration.`

Ça signifie :

- Terraform ↔ Proxmox local : OK
- conteneur LXC : OK
- VM : volontairement désactivée

### 13) Tentative SSH vers le conteneur (réseau NAT)

On a ensuite voulu faire `ssh anthony@IP_DU_CT` depuis Windows.

On a constaté que l’IP du conteneur était dans un réseau NAT VirtualBox :

- exemple observé : `10.0.2.16`

Résultat :

- `ssh anthony@10.0.2.16` → timeout

Pourquoi :

- en NAT, le réseau `10.0.2.0/24` est interne à VirtualBox : Windows n’a pas de route directe vers ce réseau.

On a envisagé le mode bridged, mais sur ce poste ça a créé trop de friction (interfaces réseau Windows multiples, IP Proxmox sur un subnet différent, ping impossible, etc.).

Décision pragmatique :

- arrêter de perdre du temps sur l’accès SSH depuis Windows tant que ce n’est pas exigé.
- utiliser l’UI Proxmox et/ou la console pour valider l’exercice.

### 14) Règle de travail adoptée (pour rester efficace)

Pour éviter l’épuisement et les changements constants :

- on ne touche plus à VirtualBox sauf nécessité absolue
- on garde Proxmox démarré
- on progresse avec Terraform sur les conteneurs LXC
- on garde une config stable : `terraform plan` puis `terraform apply`
