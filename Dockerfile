FROM ubuntu:22.04

# Установка необходимых пакетов
RUN apt-get update && apt-get install -y \
    git \
    vim \
    nano \
    curl \
    wget \
    tree \
    openssh-server \
    openssh-client \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Создание пользователя git
RUN useradd -m -s /bin/bash gituser && \
    echo "gituser:gitpass" | chpasswd && \
    usermod -aG sudo gituser

# Создание рабочей директории
WORKDIR /workspace

# Настройка SSH
RUN mkdir /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

# Настройка Git для пользователя
USER gituser
RUN git config --global user.name "Git User" && \
    git config --global user.email "git@example.com" && \
    git config --global init.defaultBranch main

# Создание .gitignore по умолчанию
RUN echo "# Git ignore file" > .gitignore && \
    echo "*.log" >> .gitignore && \
    echo "*.tmp" >> .gitignore && \
    echo ".DS_Store" >> .gitignore && \
    echo "node_modules/" >> .gitignore

# Переключение обратно на root для финальной настройки
USER root

# Создание скрипта для инициализации
RUN echo '#!/bin/bash\n\
echo "=== Git Docker Container ==="\n\
echo "Current directory: $(pwd)"\n\
echo "Git version: $(git --version)"\n\
echo "Available commands:"\n\
echo "  git init          - Initialize new repository"\n\
echo "  git clone <url>   - Clone repository"\n\
echo "  git status        - Check repository status"\n\
echo "  git add .         - Stage all changes"\n\
echo "  git commit -m msg - Commit changes"\n\
echo "  git log           - View commit history"\n\
echo "  git branch        - List branches"\n\
echo "  git checkout -b   - Create and switch to new branch"\n\
echo ""\n\
echo "Remote access:"\n\
echo "  SSH: ssh gituser@<container-ip> -p 2222"\n\
echo "  Password: gitpass"\n\
echo ""\n\
echo "Starting services..."\n\
service ssh start\n\
exec "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Установка рабочей директории
WORKDIR /workspace

# Открытие SSH порта
EXPOSE 22

# Точка входа
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"] 