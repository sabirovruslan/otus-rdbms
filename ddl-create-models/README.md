# docker-postgres

Перед запуском убедится что установлены пакеты docker и docker-compose

## Настроика окружения
В файле .env указать имя пользователя ```DB_USER``` пароль ```DB_PASSWORD``` и название контейнера ```CONTAINER_NAME```

## Запуск
```docker-compose up```

## Остановка
```ctrl + C``` или ```docker-compose down```

## Запуск bash контейнера
Из директории выполнить команду
```make bash```

или ```docker-compose exec ${CONTAINER_NAME} bash```

## Поднять Дамп
Положить дамп ```*.sql``` в директорию ```dump``` и выполнить команду Запуска

