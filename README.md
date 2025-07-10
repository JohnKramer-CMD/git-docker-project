# Git Docker Container

Готовый Docker контейнер с настроенным Git для локальной разработки.

## Быстрый старт

### 1. Сборка и запуск контейнера
```bash
# Сборка образа
docker-compose build

# Запуск контейнера
docker-compose up -d

# Настройка SSH для удаленного доступа
./setup-ssh.sh

# Подключение к контейнеру
docker-compose exec git-container bash
```

### 2. Прямой запуск через Docker
```bash
# Сборка образа
docker build -t git-workspace .

# Запуск контейнера
docker run -it --name git-container -v $(pwd)/workspace:/workspace git-workspace
```

## Использование

### Основные Git команды
```bash
# Инициализация нового репозитория
git init

# Клонирование репозитория
git clone <repository-url>

# Проверка статуса
git status

# Добавление файлов в индекс
git add .

# Создание коммита
git commit -m "Your commit message"

# Просмотр истории коммитов
git log

# Создание новой ветки
git checkout -b feature-branch

# Переключение между ветками
git checkout main
```

### Настройка Git (опционально)
```bash
# Настройка имени пользователя
git config --global user.name "Your Name"

# Настройка email
git config --global user.email "your.email@example.com"

# Настройка редактора
git config --global core.editor "nano"
```

## Структура проекта

```
Project1/
├── Dockerfile          # Конфигурация Docker образа
├── docker-compose.yml  # Docker Compose конфигурация
├── README.md          # Этот файл
├── start.sh           # Скрипт запуска
├── stop.sh            # Скрипт остановки
├── setup-ssh.sh       # Настройка SSH
├── connect.sh         # Подключение к контейнеру
├── remote-setup.md    # Документация по удаленному доступу
├── .dockerignore      # Исключения для Docker
├── ssh-keys/          # SSH ключи (создается автоматически)
└── workspace/         # Папка для ваших проектов (создается автоматически)
```

## Особенности

- ✅ Git предустановлен и настроен
- ✅ Базовые текстовые редакторы (vim, nano)
- ✅ Полезные утилиты (curl, wget, tree)
- ✅ Готовый .gitignore файл
- ✅ Персистентное хранение данных через volumes
- ✅ Интерактивный режим работы
- ✅ SSH доступ для удаленного подключения
- ✅ Автоматическая настройка SSH ключей
- ✅ Поддержка подключения с других ВМ

## Остановка контейнера

```bash
# Остановка через docker-compose
docker-compose down

# Или через Docker
docker stop git-container
docker rm git-container
```

## Удаление данных

```bash
# Удаление контейнера и volumes
docker-compose down -v

# Удаление образа
docker rmi git-workspace
```

## Удаленный доступ

### Подключение с других ВМ

```bash
# Настройка SSH на основной ВМ
./setup-ssh.sh

# Подключение по SSH ключу
ssh -i ssh-keys/id_rsa -p 2222 gituser@<IP-адрес-ВМ>

# Подключение по паролю
ssh -p 2222 gituser@<IP-адрес-ВМ>
# Пароль: gitpass

# Использование скрипта подключения
./connect.sh <IP-адрес-ВМ>
```

### Информация для подключения

| Параметр | Значение |
|----------|----------|
| **Host** | IP-адрес ВМ с контейнером |
| **Port** | 2222 |
| **User** | gituser |
| **Password** | gitpass |
| **SSH Key** | ssh-keys/id_rsa |

Подробная документация: [remote-setup.md](remote-setup.md)

## Полезные команды

```bash
# Просмотр логов контейнера
docker-compose logs git-container

# Перезапуск контейнера
docker-compose restart git-container

# Просмотр информации о контейнере
docker inspect git-container

# Проверка SSH статуса
docker-compose exec git-container service ssh status
```

## CI/CD интеграция с Jenkins

В проект встроен Jenkins для автоматического запуска сборок, тестов и деплоя при пуше в репозиторий.

- Jenkins доступен на http://localhost:8080
- Примеры pipeline и best practices: см. [ci-cd-example.md](ci-cd-example.md)

### Быстрый старт

```bash
# Запуск всех сервисов
./start.sh

# Открыть Jenkins: http://localhost:8080
# Получить пароль для первого входа
./get-jenkins-password.sh
``` 