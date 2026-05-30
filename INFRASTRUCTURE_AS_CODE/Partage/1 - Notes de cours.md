# Infrastructure As Code - Terraform

## Programme

### IaC

- Cloud et l'émergence de l'Infrastructure as Code (IaC)
- Le provisioning et la configuration.
- Les outils IaC (présentation)

### Les bases de Terraform

- L'architecture de Terraform
- Installation et configuration de Terraform
- Les langages
- HCL
  - Variables, ressources, providers et outputs
  - Cycle de vie des ressources
  - HIL
  - Expressions
  - Fonctions
  - Boucle et conditions

### Terraform avancé

- Configuration de l'environnement de développement
  - Mise en place d'aide au développement
  - Génération automatique de documentation
  - Gestion des fichiers et bonnes pratiques
- Stratégie de tests
  - Overview des différents outils de tests
- Travail coopératif
  - Re-utilisation du code, découvertes des modules
  - Gestion de la concurrence et de la persistance
  - Gestion des crédentials
- Utilisation en production
  - Manipulation du fichier état
  - Déploiement continu via Gitlab
  - Développement et utilisation de providers communautaires

## Présentation

Terraform est un outil d'Infrastructure As Code permettant de déployer des ressources aussi bien sur le Cloud que sur les infrastructures internes des entreprises.

Il fait parti de la suite logicielle proposée par Hashicorp.

- **Terraform** : provisionnement d'infrastructures
- **Packer** : création d'images de systèmes
- **Vault** : Gestion des secrets
- **Consul** : Interconnexion de services
- **Vagrant** : déploiement de machines virtuelles sur un poste de travail
- ...

Autres outils IaC :

- **Ansible** : gestion de configuration

- **Docker** / **Kubernetes** : déploiement de containers applicatifs

- Gitlab CI/CD - Github Actions - Jenkins... : CICD

- ...
