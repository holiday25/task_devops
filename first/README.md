### Написать Python приложение:
Приложение должно каждые 5 секунд проверять соединение до днс серверов 1.1.1.1 и 8.8.8.8;
По эндпоинту /health необходимо отдавать статус код 200 OK;
Сложить всё в докер и запушить в DockerHub.

Для запуска приложение вам необходимо чтобы docker был установлен на вашем хосте

При желании можно запустить команду build для сборки образа приложения а так само приложение есть на Docker Hub holiday01/devops_test:latest

```
docker build -t тегприложения . 
```
Далее запустить команду:

```
docker run -p 5000:5000 имя_образа:тег
```