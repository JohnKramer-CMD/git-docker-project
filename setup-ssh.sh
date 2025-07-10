#!/bin/bash

echo "🔑 Настройка SSH для удаленного доступа к Git контейнеру..."

# Проверка наличия Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен."
    exit 1
fi

# Создание папки для SSH ключей
mkdir -p ssh-keys

# Генерация SSH ключей если их нет
if [ ! -f "ssh-keys/id_rsa" ]; then
    echo "🔐 Генерация SSH ключей..."
    ssh-keygen -t rsa -b 4096 -f ssh-keys/id_rsa -N "" -C "git-docker-container"
    chmod 600 ssh-keys/id_rsa
    chmod 644 ssh-keys/id_rsa.pub
    echo "✅ SSH ключи созданы в папке ssh-keys/"
fi

# Копирование публичного ключа в контейнер
echo "📋 Копирование SSH ключа в контейнер..."
docker-compose exec git-container mkdir -p /home/gituser/.ssh
docker cp ssh-keys/id_rsa.pub git-container:/home/gituser/.ssh/authorized_keys
docker-compose exec git-container chown -R gituser:gituser /home/gituser/.ssh
docker-compose exec git-container chmod 700 /home/gituser/.ssh
docker-compose exec git-container chmod 600 /home/gituser/.ssh/authorized_keys

echo ""
echo "✅ SSH настроен для удаленного доступа!"
echo ""
echo "📋 Информация для подключения:"
echo "   Host: <IP-адрес-ВМ>"
echo "   Port: 2222"
echo "   User: gituser"
echo "   Password: gitpass"
echo "   SSH Key: ssh-keys/id_rsa"
echo ""
echo "🔗 Команды для подключения:"
echo "   # По SSH ключу:"
echo "   ssh -i ssh-keys/id_rsa -p 2222 gituser@<IP-адрес-ВМ>"
echo ""
echo "   # По паролю:"
echo "   ssh -p 2222 gituser@<IP-адрес-ВМ>"
echo ""
echo "📁 Ваши SSH ключи находятся в папке: ssh-keys/" 