# VPN
# R-DT
GRE 
```
conf
interface tuennel.2
ip adr 10.2.2.1
ip tunnel 192.168.33.253 192.168.33.254 mode gre
```
# FW-DT
Сетевые интерфейсы > Тунельные и там натыкать тунель
## SRV3-DT
**Установка wireguard**
```
apt-get install wireguard-tools wireguard-tools-wg-quick
```
**Генерация ключей**
```
wg genkey | tee wgkey/server_private | wg pubkey | tee wgkey/client_public
wg genkey | tee wgkey/cli_private | wg pubkey | tee wgkey/cli_public
```
