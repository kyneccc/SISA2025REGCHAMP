# 2) Docker
---
#### Установка docker и dockcer compose

``` bash
apt-get update && apt-get install docker{ce,compose}
```
**ОТ РУТА ДОБАВИТЬ ПОЛЬЗОВАТЕЛЯ ALTLINUX В ГРУППУ DOCKER**
## Docker registry
#### Настройка insecure-registry
Отредактируйте файл конфигурации Docker daemon.json:
``` bash
sudo vim /etc/docker/docker/daemon.json
```
**Добавить сторки**
``` json
{
  "storage-driver": "overlay2",
  "insecure-registries": [ "<ip-address>:5000" ]
}
```
**Запустить службу** 
``` bash 
sudo systemctl enable --now docker
```
#### Установка и запуск registry
```
  sudo docker run -d -p 5000:5000 --restart always --name registry -v dockerrepo:/var/lib/registry registry:2
```
---
## Образ app1(для будущего DeployApp.sh) 
скачать  пакет git
```
sudo apt-get install git -y
```
Скачать с гитхаба приложение 
```
git clone https://github.com/auteam-usr/champs
```
### Создание приложение и загрузка в локальный registry
переход в папку
``` bash 
cd champs/final
```
####  **ВАЖНО задать пароль пользователя altlinux > зайти в веб интерфейс>отцепить floating ip > зайти в консоль через веб > cобрать приложение >вернуть все как было**
сборка приложения

``` bash
sudo docker build -t app1:latest .
```
тегирвоания приложения
``` bash 
sudo docker tag app1 192.168.33.117:5000/app1:latest
```
загрузка в локальный репозиторий 
``` bash 
 sudo docker push 192.168.33.117:5000/app1:latest
```
---
#### Развертывание Python-скрипта в Docker
**Cоздание файла скрипта:**
``` bash
vim py.py
```
**Содержание файла:**
``` python
try:
        f = open('/root/input.txt')
        print(*f)
except FileNotFoundError:
    print('Ошибка: нет такого файла')
````
**файл input.txt**
``` bash
echo python script works! > input.txt
```
##### Docker файл file-copy-python.yml
``` bash
vim file-copy-python.yml
```
Содержание файла file-copy-python.yml
``` yml
FROM python:3.8
COPY py.py /root/
COPY input.txt /root/
CMD python3 /root/py.py
```
Сборка докер образа:
``` bash 
docker build -t file-copy-python:latest -f /home/altlinux/file-copy-python.yml .
```
Проверка:
``` bash
docker run   file-copy-python
```
---
### Развертывание WordPress с использованием Docker Compose
содержание файла wordpress.yml
``` yaml
ervices:
  mysql:
    image: mysql:5.7
    hostname: wp_database
    container_name: wp_database
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    networks:
      - wordpress-network
    environment:
      TZ: "Europe/Moscow"
      MYSQL_ROOT_PASSWORD: kfwkbfwrjgwrw39241581245u346jh3636h3h6
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: P@ssw0rd

  wordpress:
    depends_on:
      - mysql
    image: wordpress:latest
    hostname: wp_app
    container_name: wp_app
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "80:80"
    restart: always
    networks:
      - wordpress-network
    environment:
      TZ: "Europe/Moscow"
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: P@ssw0rd
      WORDPRESS_DB_NAME: wordpress


volumes:
  db_data:
  wordpress_data:
networks:
  wordpress-network:
```
**Запуск wordpress**
```
docker compose -f  wordpress.yml  up -d
```
### Развертывание базового стека ELK
```bash
vim elk.yml
```
**Cодержание файла:**
```yml
version: '3.7'

services:
  elasticsearch:
    image: elasticsearch:7.10.1
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
    ports:
      - "9200:9200"
    networks:
      - elk
    restart: always

  logstash:
    image: logstash:7.10.1
    container_name: logstash
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    environment:
      - LS_JAVA_OPTS=-Xmx256m -Xms256m
    networks:
      - elk
    depends_on:
      - elasticsearch
    restart: always

  kibana:
    image: kibana:7.10.1
    container_name: kibana
    ports:
      - "5601:5601"
    networks:
      - elk
    depends_on:
      - elasticsearch
    restart: always
networks:
  elk:
    driver: bridge
```
**Содержание logstash.conf:**
```

 input {
     tcp {
         port => 5000
     }
     http {

         port => 8091
     }
 }

 output {
     elasticsearch {
         hosts => ["elasticsearch:9200"]
         index => "first-logstash"
         ssl_certificate_verification => false
         user => "elastic"
         password => "P@ssw0rd"

     }

```
