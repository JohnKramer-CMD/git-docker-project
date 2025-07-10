# CI/CD с Jenkins для Git Docker контейнера

## Быстрый старт

1. Запустите все сервисы:
   ```bash
   docker-compose up -d
   ```
2. Откройте Jenkins: http://localhost:8080
3. Получите пароль для первого входа:
   ```bash
   docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
4. Пройдите первичную настройку Jenkins (установите плагины, создайте пользователя).
5. Создайте новый Pipeline проект.
6. В настройках укажите путь к вашему репозиторию (например, /workspace/your-repo).
7. Вставьте пример Jenkinsfile (см. ниже).

---

## Пример Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git url: 'file:///workspace/your-repo', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                sh 'echo "Сборка проекта..."'
                # Здесь ваша команда сборки, например: make build
            }
        }
        stage('Test') {
            steps {
                sh 'echo "Запуск тестов..."'
                # Здесь ваша команда тестирования, например: make test
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo "Деплой..."'
                # Здесь ваша команда деплоя
            }
        }
    }
}
```

---

## Примеры команд для команды

- **Добавить новый репозиторий:**
  ```bash
  cd workspace
  git init --bare my-repo.git
  ```
- **Клонировать репозиторий:**
  ```bash
  git clone ssh://gituser@<IP-адрес-ВМ>:2222/workspace/my-repo.git
  ```
- **Пушить изменения:**
  ```bash
  git add .
  git commit -m "Мой коммит"
  git push origin main
  ```

---

## Best Practices

- Используйте feature-ветки для разработки.
- Настройте webhooks или polling в Jenkins для автоматического запуска pipeline при пуше.
- Храните Jenkinsfile в корне каждого репозитория.
- Добавьте badge статуса сборки в README.
- Регулярно делайте backup workspace и jenkins_home.

---

## Полезные ссылки
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Jenkins Docker Guide](https://www.jenkins.io/doc/book/installing/docker/) 