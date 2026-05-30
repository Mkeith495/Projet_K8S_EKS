# IaC - Terraform

Pour la réalisation des exercices suivants, vous pourrez vous appuyer sur le support en ligne présent à cette [adresse](https://blog.stephane-robert.info/docs/infra-as-code/provisionnement/terraform/).

## 1. Rôle de Terraform

**Terraform** et **Ansible** sont souvent comparés. Ils peuvent être coparables sur certains points mais ils sont surtout complémentaires.

1. Décrire un scénario dans lequel Terraform pourrait être utilisé en tant que complément d'Ansible.

2. Si vous avez ces deux outils déjà installés, faites-en la démonstration.

## 2. Installation

1. Si ça n'est pas déjà fait, installez Terrafom sur votre poste de travail et testez son bon fonctionnement avec la commande `terraform version`. 

2. **OpenToFu** étant un fork parfaitement libre de Terraform, vous l'installerez aussi sur votre poste de travail et validerez aussi son installation en utilisant la commande `tofu version`.

## EXERCICE 1 - Premiers déploiements

Afin de tester Terraform, vous allez travailler dans un premier temps en intéragissant avec un serveur Proxmox.

1. Installez un serveur Proxmox sur un Hyperviseur local (KVM, VMWare Workstation, Hyper-V...). Ce serveur Proxmox devra être accessible depuis la machine sur laquelle vous avez installé Terraform.

2. Téléchargez le template de container **Alma Linux 10** à partir des dépôts fournis par Proxmox.

3. Déployez avec Terraform un container nommé `alma1` basé sur cette image.

4. Créez un VM template d'un Ubuntu Server 24.04 et nommez-la `ubuntu-2404-template`. Pensez à install le paquet `qemu-guest-agent` et à réinitialiser le machine-id de la manière suivante :

```shell
sudo -i
rm /var/lib/dbus/machine-id
echo > /etc/machine-id
```

5. Déployez avec Terraform un clone de ce template et nommez-le `ubuntu-vm-01`.

Comme vous pouvez le constater, il y a peu de contrôle sur le réseau et la personnalisation de la machine virtuelle créée.

6. Récupérez les images Cloud de [Debian](https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2) et d'[Ubuntu](https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img) et crééz des modèles de VM à partir de ces images. Nommez-les `ubuntu-cloudinit` et `debian-cloudinit`.

7. Créez des VM à partir de ces modèles et utilisez `cloud-init`, pour personnaliser le déploiement du clone en définissant son hostname à `ubuntu-vm-01` et en lui affectant une adresse IP statique et en définissant un utilisateur.




## EXERCICE 2 - Travail sur plusieurs plateformes

1. Variabilisez votre travail sur l'exercice 1 de manière à pouvoir changer facilement de serveur.
2. Déployez les containers et serveurs précédents sur les serveurs proxmox-form et pve-avalone dont les coordonnées vous ont été données dans un autre fichier de ce partage.

## EXERCICE 3 - Boucles

1. Déployez 4 containers et 2 VM à partir des modèles utilisés précédemment. Nommez vos machines en suivant le schéma suivant : debian-ct-nb-nom (exemple : debian-ct-03-masset, debian-vm-02-masset).
2. Définissez une liste d'utilisateurs.
3. Créez un pool pour chaque utilisateur nommé du nom de l'utilisateur.
4. Définissez un compte utilisateur pour chacun de ces utilisateurs.
5. Définissez une permission niveau utilisateur pour chacune de ces utilisateurs sur leur pool.
6. Déployez une vm et un container pour chaque utilisateur et associez-les au pool approprié.

## EXERCICE 4 - Déploiement applicatif

Dans cet exercice, vous allez déployer l'application disponible sur le dépôt suivant : https://gl.avalone-fr.com/anthony/codepostal.

Il s'agit d'une application PHP / MySQL simple prévue pour être déployée par Docker.

1. Déployez cette application sur une VM ou un container sans utiliser Docker mais en déployant tout le nécessaire pour qu'elle fonctionne : apache, php, mysql-server, git...
2. Déployez cette même application en répartissant la partie php sur un serveur et la partie mysql sur un autre.
3. Déployez cette même application en vous appuyant sur Docker.