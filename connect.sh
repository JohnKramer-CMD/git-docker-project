#!/bin/bash

# Скрипт для подключения к Git контейнеру с других ВМ

CONTAINER_IP=${1:-"localhost"}
SSH_PORT=${2:-"2222"}
SSH_USER=${3:-"gituser"}
SSH_KEY=${4:-"ssh-keys/id_rsa"}

echo "🔗 Подключение к Git контейнеру..."
echo "   Host: $CONTAINER_IP"
echo "   Port: $SSH_PORT"
echo "   User: $SSH_USER"
echo ""

# Проверка наличия SSH ключа
if [ -f "$SSH_KEY" ]; then
    echo "🔐 Подключение по SSH ключу..."
    ssh -i "$SSH_KEY" -p "$SSH_PORT" "$SSH_USER@$CONTAINER_IP"
else
    echo "🔑 Подключение по паролю..."
    echo "   Пароль: gitpass"
    ssh -p "$SSH_PORT" "$SSH_USER@$CONTAINER_IP"
fi 