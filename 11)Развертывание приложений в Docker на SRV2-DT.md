# Развертывание приложений в Docker на SRV2-DT

## Установка Docker и Docker Compose

Обновите пакеты и установите Docker и Docker Compose:

```bash
  apt-get update &&   apt-get install docker-{engine,compose} -y
```

Включите и запустите службы Docker:

```bash
  systemctl enable --now docker.service
  systemctl enable --now docker.socket
```

## Настройка Docker Registry

### Настройка insecure-registry

Отредактируйте файл конфигурации Docker `daemon.json`:

```bash
  vim /etc/docker/daemon.json
```

Добавьте следующие строки после секции `storage`, не забудьте поставить запятую перед добавлением новых параметров:

```json
{
  "storage-driver": "overlay2",
  "insecure-registries": ["192.168.33.67:5000", "srv2-dt.au.team"]
}
```

Перезапустите службу Docker для применения изменений:

```bash
 systemctl restart docker.service
```

### Запуск Docker Registry

Запустите Docker Registry контейнер:

```bash
  docker run -d -p 5000:5000 --restart always --name registry -v dockerrepo:/var/lib/registry registry:2
```

## Создание и развертывание приложения Web

### Создание HTML файла

Создайте файл `/root/index.html` с содержимым:

```html
<html>
<body>
  <center><h1><b>WEB</b></h1></center>
</body>
</html>
```

### Создание Dockerfile

Создайте файл `/root/Dockerfile` с содержимым:

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
```

### Сборка Docker образа

Соберите Docker образ с тегом `web:v1.0`:

```bash
  docker build -t web:v1.0 .
```

### Тегирование и отправка образа в реестр

Тегируйте образ для вашего локального реестра:

```bash
  docker tag web:v1.0 192.168.33.67:5000/web:1.0
```

Отправьте образ в ваш локальный реестр:

```bash
  docker push 192.168.33.67:5000/web:1.0
```

### Запуск контейнера из образа в реестре

Запустите контейнер из образа в вашем локальном реестре:

```bash
  docker run -d -p 80:80 --restart always --name web 192.168.33.67:5000/web:1.0
```

Теперь ваше приложение должно быть доступно по адресу `http://<IP_сервера>/`.
