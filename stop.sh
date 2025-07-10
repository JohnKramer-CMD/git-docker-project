#!/bin/bash

echo "🛑 Остановка Git Docker контейнера..."

# Проверка наличия Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен."
    exit 1
fi

# Остановка контейнера
echo "⏹️  Остановка контейнера..."
docker-compose down

echo ""
echo "✅ Контейнер остановлен!"
echo ""
echo "🔄 Для повторного запуска выполните:"
echo "   ./start.sh"
echo ""
echo "🗑️  Для полного удаления (включая volumes) выполните:"
echo "   docker-compose down -v" 