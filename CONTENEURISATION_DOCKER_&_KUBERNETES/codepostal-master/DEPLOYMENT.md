# Déploiement Docker – Projet Codepostal (notes de cours)

Ce document explique **ce qu’on a fait** pour :

- lancer l’application en Docker en local
- résoudre le blocage de port
- builder/pusher l’image sur Docker Hub
- déployer sur un serveur qui utilise **Nginx** pour router chaque étudiant via un chemin `/<nom>/`

> Objectif : que tu puisses relire et comprendre le déroulé.

---

## 1) Rappels : de quoi est composé le projet

Le projet est une petite application **PHP/Apache** + une base **MySQL**.

- Le service **php** sert l’interface web.
- Le service **mysql** contient la base de données (initialisée via `cp.sql`).

L’application PHP lit les variables d’environnement suivantes (dans `php/www/connect.php`) :

- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

---

## 2) Lancer en local avec Docker Compose

### Commande standard
Depuis la racine du projet :

```bash
docker compose up -d --build
```

- `--build` force la reconstruction des images si nécessaire.
- `-d` lance en arrière-plan.

### Vérification

```bash
docker compose ps
```

Tu dois voir **au moins** :

- un conteneur `mysql` en `Up`
- un conteneur `php` (ou `web`) en `Up`

### Accès navigateur

Si le service web expose `8080:80` :

- `http://localhost:8080/`

---

## 3) Problème rencontré : le port 8080 déjà utilisé

### Symptôme
Au lancement :

- `ports are not available`
- `listen tcp 0.0.0.0:8080: bind: Only one usage of each socket address ...`

### Ce que ça veut dire
Sur ta machine, un autre programme utilisait déjà **le port 8080**.

### Contournement choisi
Au lieu de libérer le port 8080, on a décidé d’utiliser **8081**.

Donc l’accès navigateur devient :

- `http://localhost:8081/`

---

## 4) Publier l’image PHP sur Docker Hub (push)

### Pourquoi `docker compose push` échouait au début
Le push échouait car :

- l’image n’existait pas localement sous le bon nom (`tag does not exist`)
- ensuite, on a eu des erreurs réseau (`400 Bad request` puis même `no such host`) car ta connexion internet était instable

### Étapes correctes

1) Connexion Docker Hub :

```bash
docker login
```

2) Builder l’image avec le bon nom (le namespace doit correspondre à ton compte Docker Hub)

Exemple avec ton compte :

- `mkeith495/codepostal-php:latest`

Commande (si le `docker-compose.yml` est configuré pour builder/tagger) :

```bash
docker compose build php
```

3) Push :

```bash
docker push mkeith495/codepostal-php:latest
```

### Test important (diagnostic)
On a vérifié que Docker Hub acceptait bien un push basique avec `hello-world` :

```bash
docker pull hello-world
docker tag hello-world mkeith495/push-test:latest
docker push mkeith495/push-test:latest
```

Ce test a **réussi**, donc le problème venait plutôt de la stabilité réseau au moment d’uploader de grosses couches.

### Résultat final
Le push de `mkeith495/codepostal-php:latest` a fini par réussir (toutes les couches “Layer already exists” + “Pushed” + digest final).

---

## 5) Déploiement sur le serveur (srv-cp…) avec Nginx

### Ce que fait Nginx sur le serveur
Sur ce serveur, Nginx sert de routeur/reverse-proxy pour plusieurs étudiants.

Le prof accède à des pages du style :

- `https://srv-cp.avalone-formation.com/<nom_etudiant>/`

Chaque `/<nom_etudiant>/` pointe vers l’application Docker de l’étudiant (souvent via un port local différent).

### Pourquoi tu n’arrivais pas à recharger Nginx
Tu as eu :

- `Failed to reload nginx.service: Access denied`

Cela signifie :

- ton utilisateur n’a pas les droits `sudo` pour recharger/éditer Nginx

Donc **toi** tu peux :

- lancer tes conteneurs
- prouver qu’ils répondent en local sur le serveur

Mais la conf Nginx et le reload doivent être faits par un compte admin / ton prof.

### Méthode simple côté étudiant : exposer le conteneur web sur un port local du serveur
Sur le serveur, tu crées un dossier :

```bash
mkdir -p ~/mkeith495
cd ~/mkeith495
```

Puis tu crées un `docker-compose.yml` (sur le serveur) qui :

- lance `mysql`
- lance `php`
- expose `php` sur `127.0.0.1:10081` (exemple)

Exemple :

```yaml
services:
  mysql:
    image: anthonymasset/codepostal-mysql:latest
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_PASSWORD}
    restart: unless-stopped

  php:
    image: mkeith495/codepostal-php:latest
    environment:
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_NAME=cp
      - DB_USER=root
      - DB_PASSWORD=${DB_PASSWORD}
    ports:
      - "127.0.0.1:10081:80"
    depends_on:
      - mysql
    restart: unless-stopped
```

Et un fichier `.env` :

```env
DB_PASSWORD=un_mot_de_passe_fort
```

Puis lancement :

```bash
docker compose up -d
docker compose ps
```

### Test local sur le serveur

```bash
curl -I http://127.0.0.1:10081/
```

Si tu reçois une réponse HTTP, ton app tourne.

### Ce que le prof/admin doit ajouter dans Nginx
Bloc conceptuel (exemple) :

```nginx
location /mkeith495/ {
  proxy_pass http://127.0.0.1:10081/;
}
```

Puis reload Nginx (fait par l’admin).

---

## 6) Ce que tu dois retenir

- Un `docker compose ps` qui montre uniquement `mysql` => le web ne tourne pas, donc le navigateur n’affiche rien.
- `bind 8080 already in use` => soit tu libères 8080, soit tu changes de port (8081).
- Pour `push`, le tag doit être dans ton namespace Docker Hub (ex `mkeith495/...`).
- Sur un serveur multi-étudiants, Nginx sert souvent de “routeur” via des chemins `/<nom>/`.
- Si tu n’as pas `sudo`, tu ne peux pas recharger Nginx : tu lances tes conteneurs et tu donnes le port à l’admin.

---

## Commandes utiles (récap)

### Local
```bash
docker compose up -d --build
docker compose ps
docker compose logs -f
```

### Docker Hub
```bash
docker login
docker compose build php
docker push mkeith495/codepostal-php:latest
```

### Serveur
```bash
docker compose up -d
docker compose ps
curl -I http://127.0.0.1:10081/
```
