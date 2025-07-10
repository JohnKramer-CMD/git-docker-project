# Удаленный доступ к Git контейнеру

Этот документ описывает как настроить и использовать удаленный доступ к Git контейнеру с других виртуальных машин.

## 🚀 Быстрая настройка

### 1. На основной ВМ (где запущен контейнер)

```bash
# Запуск контейнера
./start.sh

# Настройка SSH
./setup-ssh.sh
```

### 2. На клиентских ВМ

```bash
# Копирование SSH ключа
scp user@main-vm-ip:~/Project1/ssh-keys/id_rsa ~/.ssh/git-container-key
chmod 600 ~/.ssh/git-container-key

# Подключение
ssh -i ~/.ssh/git-container-key -p 2222 gituser@main-vm-ip
```

## 🔧 Способы подключения

### 1. SSH подключение

#### По SSH ключу (рекомендуется)
```bash
ssh -i ssh-keys/id_rsa -p 2222 gituser@<IP-адрес-ВМ>
```

#### По паролю
```bash
ssh -p 2222 gituser@<IP-адрес-ВМ>
# Пароль: gitpass
```

### 2. Docker команды

#### Прямое подключение к контейнеру
```bash
# С основной ВМ
docker-compose exec git-container bash

# С других ВМ (если Docker доступен)
docker exec -it git-container bash
```

### 3. Использование скрипта connect.sh

```bash
# Подключение к localhost
./connect.sh

# Подключение к удаленной ВМ
./connect.sh 192.168.1.100

# Подключение с кастомным портом
./connect.sh 192.168.1.100 2222

# Подключение с кастомным пользователем
./connect.sh 192.168.1.100 2222 gituser
```

## 📋 Информация для подключения

| Параметр | Значение |
|----------|----------|
| **Host** | IP-адрес ВМ с контейнером |
| **Port** | 2222 |
| **User** | gituser |
| **Password** | gitpass |
| **SSH Key** | ssh-keys/id_rsa |

## 🔐 Настройка SSH ключей

### Автоматическая настройка
```bash
./setup-ssh.sh
```

### Ручная настройка
```bash
# 1. Генерация ключей
ssh-keygen -t rsa -b 4096 -f ssh-keys/id_rsa -N ""

# 2. Копирование в контейнер
docker cp ssh-keys/id_rsa.pub git-container:/home/gituser/.ssh/authorized_keys

# 3. Настройка прав
docker-compose exec git-container chown -R gituser:gituser /home/gituser/.ssh
docker-compose exec git-container chmod 700 /home/gituser/.ssh
docker-compose exec git-container chmod 600 /home/gituser/.ssh/authorized_keys
```

## 🌐 Сетевая настройка

### Проверка доступности
```bash
# Проверка порта
telnet <IP-адрес-ВМ> 2222

# Или через nmap
nmap -p 2222 <IP-адрес-ВМ>
```

### Настройка файрвола
```bash
# Ubuntu/Debian
sudo ufw allow 2222

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --reload
```

## 📁 Работа с файлами

### Копирование файлов через SCP
```bash
# Копирование файла в контейнер
scp -P 2222 -i ssh-keys/id_rsa file.txt gituser@<IP-адрес-ВМ>:/workspace/

# Копирование файла из контейнера
scp -P 2222 -i ssh-keys/id_rsa gituser@<IP-адрес-ВМ>:/workspace/file.txt ./
```

### Синхронизация папки workspace
```bash
# Монтирование через SSHFS
sshfs -p 2222 -o IdentityFile=ssh-keys/id_rsa gituser@<IP-адрес-ВМ>:/workspace ./remote-workspace
```

## 🔧 Настройка Git для удаленной работы

### Настройка пользователя
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Настройка репозитория
```bash
# Инициализация
git init

# Добавление удаленного репозитория
git remote add origin <repository-url>

# Клонирование
git clone <repository-url>
```

## 🛠️ Устранение неполадок

### Проблема: Connection refused
```bash
# Проверка статуса контейнера
docker-compose ps

# Перезапуск контейнера
docker-compose restart git-container

# Проверка логов
docker-compose logs git-container
```

### Проблема: Permission denied
```bash
# Проверка прав SSH ключа
chmod 600 ssh-keys/id_rsa

# Проверка прав в контейнере
docker-compose exec git-container ls -la /home/gituser/.ssh/
```

### Проблема: SSH key not found
```bash
# Пересоздание SSH ключей
rm -rf ssh-keys/
./setup-ssh.sh
```

## 📞 Полезные команды

```bash
# Проверка статуса SSH в контейнере
docker-compose exec git-container service ssh status

# Просмотр SSH логов
docker-compose exec git-container tail -f /var/log/auth.log

# Проверка открытых портов
docker-compose exec git-container netstat -tlnp

# Тест SSH подключения
ssh -o ConnectTimeout=5 -p 2222 gituser@localhost
``` 