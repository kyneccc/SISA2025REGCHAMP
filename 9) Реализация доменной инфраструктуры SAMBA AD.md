# 9) Реализация доменной инфраструктуры SAMBA AD 
## SRV1-HQ
``` bash
apt-get install bind bind-utils  task-samba-dc -y
control bind-chroot disabled
```
Настроить DNS на 192.168.11.66
```
vim /etc/sysconfig/bind
```
Добавить строку:
 > KRB5RCACHETYPE= «none»
```
vim  /etc/bind/named.conf
```
### Добавить строку:
> include "/var/lib/samba/bind-dns/named.conf";
```
vim /etc/bind/options.conf
```
### Добавить строки: 
> tkey-gssapi-keytab "/var/lib/samba/bind-dns/dns.keytab";  
> minimal-responses yes;  
> allow-ransfer { 192.168.33.66; }
### Отредактировать строки:
> forwarders { 8.8.8.8; };  
> allow-transfer {  192.168.33.66; };

### Cоздание master сервера:
``` bash
rm -f /etc/samba/smb.conf
samba-tool domain provision
systemctl enable --now samba
systemctl enable --now bind
samba-tool dns add 192.168.11.66 test.alt srv1-dt A 192.168.33.66 -U administrator
```

## SRV1-DT
``` bash
apt-get install bind bind-utils task-samba-dc -y
control bind-chroot disabled
```
### Настроить DNS на 192.168.11.66
```
vim /etc/sysconfig/bind
```

Добавить строку:
> KRB5RCACHETYPE= «none»
```
vim  /etc/bind/named.conf
```
Добавить строку: 
> include "/var/lib/samba/bind-dns/named.conf";
```
vim /etc/bind/options.conf
```
### Добавить строки:
> tkey-gssapi-keytab "/var/lib/samba/bind-dns/dns.keytab";  
> minimal-responses yes;
### Отредактировать строки:
> forwarders { 8.8.8.8; };  
> allow-recursion {  192.168.33.66; }
```
rm -f /etc/samba/smb.conf
vim /etc/krb5.conf
```
> default_realm = <domaim-search>  
> dns_lookup_realm = falsedns_lookup_kdc = true  
> kinit administrator@AU.TEAM
```
samba-tool domain join au.team DC -Uadministrator --realm=au.team --dns-backend=BIND9_DLZ (все опции обязательны)
systemctl enable —now samba
systemctl enable —now bind
```


### Создайте 30 пользователей user1-user30 с паролем P@ssw0rd
``` bash
for i in {1..30}; do echo ‘P@ssw0rd’ | samba-tool user create user$i password=P@ssw0rd; done
```
### Пользователи user1-user10 должны входить в состав группы group1.
``` bash
for i in {1..10}; do echo ‘P@ssw0rd’ | samba-tool group addmembers group1 user$i ; done
```
### Пользователи user11-user20 должны входить в состав группы group2.
```
for i in {11..20}; do echo ‘P@ssw0rd’ | samba-tool group addmembers group2 user$i ; done
```
### Пользователи user21-user30 должны входить в состав группы group3.
```
for i in {21..30}; do echo ‘P@ssw0rd’ | samba-tool group addmembers group3 user$i ; done
```
## Общая папка на SRV1-HQ
```
mkdir /opt/data 
chmod -R 0755 /opt/data
vim /etc/samba/smb.conf
```
> [SAMBA]
> path=/opt/data  
> read only = No  
> browsable = yes
#### монтировать в admc как сетевой диск

## Подключение клиентов к samba
### admin-hq 
```
apt-getupdate && apt-get  install gpupdate gpui gputils admc -y
```
### на других машинах
```
apt-getupdate && apt-get  install gpupdate
```
№ Настройка DNS сервера
### SRV1-HQ
```
 samba-tool dns add 192.168.11.66 test.alt <Имя устройства> A <ip-address> -U administrator
samba-tool dns add <FQDN dns сервера>11.168.192.in-addr.arpa <последний октет ip адреса> PTR <FQDN хоста> -U administrator
```
на всех машинах прописать оба dns сервера


