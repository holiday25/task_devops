Деплой приложения на хост
Примечание: Виртуальную машину можно поднять у себя (Ubuntu 18).

Используя Ansible написать конфигурацию по деплою контейнера с приложением;
Написать роль, которая создаёт юзеров, группу и деплоит необходимые ssh ключи.

Примечание: Был использован (Ubuntu 22.04)

Чтобы запустить команду вам необхожимо быть в папке ansible_dev
Команда для запуска:
```
ansible-playbook -i inventory main.yml
```
