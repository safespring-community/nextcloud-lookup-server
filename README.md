# SUNET Nextcloud

## Prerequisits

### Docker

    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker ubuntu

Remember to log out and back in for this to take effect!

Installation instructions: https://docs.docker.com/engine/install/ubuntu/

### Docker Compose

    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

Installation instructions: https://docs.docker.com/compose/install/

### s3cmd

    sudo apt install s3cmd

## Lookup server

Nextcloud's Lookup-Server [documentation](https://github.com/nextcloud/lookup-server).

### Deploying Lookup server

#### Configure

Set values in

- lookup.env
- db.env

based on *.env_template files.

#### Deploy

Use `redeploy.sh` script to build docker images and deploy the complete solution

    ./redeploy.sh

### Redeploy

Use `redeploy.sh` script to redeploy the solution (except the Let's Encrypt container)

    ./redeploy.sh

`-p` - prune docker volumes (except the one with SSL certificates)

### Destroying the deployment

    docker-compose down

    docker volume prune

Warning: do not prune the Let's Encrypt volumes too often, otherwise you might hit a limit on [Certificates per Registered Domain (50 per week)](https://letsencrypt.org/docs/rate-limits/).

### Debugging

#### Lookup DB

    docker exec -u root -it nextcloud-lookup-server_db_1 bash
    mysql -u root -p
    use lookup
    show tables;

#### Redeploy Lookup server

    docker rm -f nextcloud-lookup-server_app_1 nextcloud-lookup-server_db_1 nextcloud-lookup-server_proxy_1
    docker volume prune -f
    docker build --no-cache -t jakubkrzywda/lookup:apache .

    docker-compose up -d

### Upgrade Version

#### Application

In the Dockerfile, change the value of `LOOKUP_VERSION` variable and rebuild the Docker image.

#### MySQL schema

Download the database schema for the appropriate Lookup server.

Example for version 0.3.2:

    wget https://raw.githubusercontent.com/nextcloud/lookup-server/v0.3.2/mysql.dmp
