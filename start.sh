#!/bin/bash

echo "🚀 Запуск Git Docker контейнера..."

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Установите Docker и попробуйте снова."
    exit 1
fi

# Проверка наличия docker-compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен. Установите Docker Compose и попробуйте снова."
    exit 1
fi

# Создание папки workspace если её нет
if [ ! -d "workspace" ]; then
    echo "📁 Создание папки workspace..."
    mkdir -p workspace
fi

# Сборка образа
echo "🔨 Сборка Docker образа..."
docker-compose build

# Запуск контейнера
echo "▶️  Запуск контейнера..."
docker-compose up -d

# Проверка статуса
echo "📊 Статус контейнера:"
docker-compose ps

echo ""
echo "✅ Git контейнер запущен!"
echo ""
echo "🔗 Для подключения к контейнеру выполните:"
echo "   docker-compose exec git-container bash"
echo ""
echo "📂 Ваши файлы будут доступны в папке ./workspace"
echo ""
echo "🛑 Для остановки контейнера выполните:"
echo "   docker-compose down" 