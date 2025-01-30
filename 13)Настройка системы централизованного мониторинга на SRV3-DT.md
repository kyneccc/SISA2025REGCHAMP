# Настройка системы централизованного мониторинга на SRV3-DT

## Подготовка

Обновите пакеты и установите необходимые компоненты:

```bash
 apt-get update
 apt-get install postgresql16-server zabbix-server-pgsql fping -y
 apt-get install apache2 apache2-mod_php8.2 -y
 apt-get install php8.2 php8.2-{mbstring,sockets,gd,xmlreader,pgsql,ldap,openssl} -y
```

## Создание базы данных

Инициализируйте сервер PostgreSQL:

```bash
 /etc/init.d/postgresql initdb
 systemctl enable --now postgresql
```

Создайте пользователя и базу данных для Zabbix:

```bash
createuser --no-superuser --no-createdb --no-createrole --encrypted --pwprompt zabbix -U postgres
createdb -O zabbix zabbix -U postgres
```

Загрузите схему и данные в базу данных:

```bash
psql -f /usr/share/doc/zabbix-common-database-pgsql-7.0.8/schema.sql zabbix -U zabbix
psql -f /usr/share/doc/zabbix-common-database-pgsql*/images.sql zabbix -U zabbix
psql -f /usr/share/doc/zabbix-common-database-pgsql*/data.sql zabbix -U zabbix
```

## Настройка PHP

Отредактируйте конфигурацию PHP:

```bash
 vim /etc/php/8.2/apache2-mod_php/php.ini
```

Добавьте или измените следующие параметры:

```ini
memory_limit = 256M
post_max_size = 32M
max_execution_time = 600
max_input_time = 600
date.timezone = Europe/Moscow
always_populate_raw_post_data = -1
```

## Настройка и запуск Zabbix сервера

Отредактируйте конфигурацию Zabbix сервера:

```bash
 vim /etc/zabbix/zabbix_server.conf
```

Добавьте или измените следующие параметры:

```ini
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=ВашПароль
```

Включите и запустите службу Zabbix сервера:

```bash
 systemctl enable --now zabbix_pgsql
```

## Установка веб-интерфейса Zabbix

Установите метапакеты для веб-интерфейса:

```bash
 apt-get install zabbix-phpfrontend-apache2 zabbix-phpfrontend-php8.2 -y
```

Включите аддоны в Apache2:

```bash
 ln -s /etc/httpd2/conf/addon.d/A.zabbix.conf /etc/httpd2/conf/extra-enabled/
 systemctl enable --now httpd2
```

**ОБЯЗАТЕЛЬНО ПОМЕНЯТЬ ПАРОЛЬ ДЛЯ ПОЛЬЗОВАТЕЛЯ ADMIN В ВЕБ-ИНТЕРФЕЙСЕ**

## Настройка клиентов

На клиентах установите агента Zabbix:

```bash
 apt-get update &&  apt-get install zabbix-agent -y
```

Отредактируйте конфигурацию агента:

```bash
 vim /etc/zabbix/zabbix_agentd.conf
```

Добавьте или измените следующие параметры:

```ini
Server=<IP_сервера>
ServerActive=<IP_сервера>
Hostname=freeipa.example.test
```

## Настройка в веб-морде

В веб-интерфейсе Zabbix:

1. Перейдите в раздел "Настройка" -> "Узлы сети".
2. Создайте новый узел сети.
3. **ОБЯЗАТЕЛЬНО УКАЖИТЕ ШАБЛОН** для нового узла.

Теперь ваша система централизованного мониторинга должна быть настроена и готова к использованию.
```

Этот текст можно скопировать и вставить в файл README.md в вашем репозитории на GitHub. Он содержит все необходимые шаги и команды для настройки системы централизованного мониторинга Zabbix на сервере SRV3-DT.
