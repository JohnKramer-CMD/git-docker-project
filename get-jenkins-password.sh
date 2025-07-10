#!/bin/bash

echo "Пароль для первого входа в Jenkins:"
docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 