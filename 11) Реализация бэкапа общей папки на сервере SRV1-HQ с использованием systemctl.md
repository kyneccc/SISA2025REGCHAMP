Реализация бэкапа общей папки на сервере SRV1-HQ с использованием systemctl.
```
mkdir /var/bac
vim /etc/systemd/system/backup.service
```
>[Unit]  
>[Service]  
> ExecStart= tar –czf /var/bac/backup.tar.gz /opt/data  
>[Install]
WantedBy=multi-user.target
```
vim /etc/systemd/system/backup.timer
```
> [Unit]  
> [Timer]  
> OnCalendar=*-*-* 20:00:00  
> OnBootSec-10  
> [Install]  
> WantedBy=multi-user.target
```
systemctl enable --now backup.timer
```
