## Офис HQ
### R-HQ
``` IOS
En
Conf t 
Ip pool CLI-HQ 192.168.11.3-192.168.11.60
dhcp-server 1
  gateway 192.168.11.1
ntp 192.168.11.66
  domain-search au.team
   mask 26
   dns 192.168.11.66, 192.168.33.66
   pool CLI-HQ 1
  exit
Interface VLAN110
 dhcp-server 1
write
```
### CLI-HQ
```
mkdir /etc/net/ifaces/ens18
vim /etc/net/ifaces/ens18/options(TYPE=eth \ BOOTPROTO=dhcp)
systemctl disable —now NetworkManager
reboot
```
## Офис dt
### R-dt
```
En
Conf t 
Ip pool CLI-DT 192.168.33.3-192.168.33.60
dhcp-server 1
 gateway 192.168.33.1
ntp 192.168.11.66
 domain-search au.team
 mask 26
 Dns 192.168.33.66, 192.168.33.66
 Pool CLI-DT 1
Interface FW-DT
  dhcp-server 1
write
```
## FW-DT

Dhcp-server ->  добавить (интерфейс VLAN110, режим работы Relay ip адресс внешнего dhcp сервера 192.168.33.253)

если совсем все плохо будет то
ip r add 0.0.0.0/0 via 192.168.33.253 dev <имя интерфейса>`()   

### CLI-HQ
```
mkdir /etc/net/ifaces/ens18
vim /etc/net/ifaces/ens18/options(TYPE=eth \ BOOTPROTO=dhcp)
systemctl disable —now NetworkManager
reboot
