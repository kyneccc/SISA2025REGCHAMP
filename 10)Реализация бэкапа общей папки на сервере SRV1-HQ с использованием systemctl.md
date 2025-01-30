


# Реализация бэкапа общей папки на сервере SRV1-HQ с использованием systemctl

## Создание директории для хранения бэкапов

```bash
mkdir /var/bac
```

## Создание сервисного файла для бэкапа

Создайте файл `/etc/systemd/system/backup.service` с следующим содержимым:

```ini
[Unit]
Description=Backup Service

[Service]
ExecStart=/bin/tar -czf /var/bac/backup.tar.gz /opt/data

[Install]
WantedBy=multi-user.target
```

## Создание таймерного файла для автоматического запуска бэкапа

Создайте файл `/etc/systemd/system/backup.timer` с следующим содержимым:

```ini
[Unit]
Description=Run Backup Daily

[Timer]
OnCalendar=*-*-* 20:00:00
OnBootSec-10

[Install]
WantedBy=multi-user.target
```

## Включение и запуск сервиса и таймера

Для включения и запуска сервиса и таймера выполните следующие команды:

```bash
sudo systemctl enable --now backup.timer
sudo systemctl start backup.service
```

### Проверка статуса

Чтобы проверить статус сервиса и таймера, используйте следующие команды:

```bash
systemctl status backup.service
systemctl status backup.timer
```

Теперь ваш бэкап будет создаваться ежедневно в 20:00, а также через 10 минут после загрузки системы.
