# VPN

# FW-DT
Сетевые интерфейсы > Тунельные и там натыкать тунель

## CLI

```
apt-get install wireguard-tools wireguard-tools-wg-quick
systemctl enable --now sshd
cd ~
mkdir/wgkey
```
## SRV3-DT
**Установка wireguard**
```
apt-get install wireguard-tools wireguard-tools-wg-quick
```
**Генерация ключей**
```
mkdir wgkey
wg genkey | tee wgkey/server_private | wg pubkey | tee wgkey/client_public
wg genkey | tee wgkey/cli_private | wg pubkey | tee wgkey/cli_public
```
**Создание конфигов**
Сервер
```
[Interface]
PrivateKey = <закрытый_ключ>
Address = <IP-адрес_сервера>
ListenPort = <Порт>
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o <Интерфейс> -j MASQUERADE 
PostDown = iptables -D FORWARD -i %i -j ACCEPT; ipta
[Peer]
PublicKey = <Открытый_ключ_клиента>
AllowedIPs = <Разрешенный_IP_адрес_для_клиента>
```
Клиент
```
[Interface]
PrivateKey = <Закрытый_ключ_клента>
Address = <IP-адрес_клиента>
[Peer]
PublicKey = <Публичный_ключ_сервера>
Endpoint = <IP-адрес_екороутера>:<Порт>
AllowedIPs = 0.0.0.0/0
```
**Включить forwarding на сервере**
и прописать
```
sysctl -p
```

## R-DT
**Пробросить порты**
ip nat source static udp 192.168.33.254 12022 172.16.4.14 12022
ip nat destination static udp 172.16.4.14 12022 192.168.33.254 12022 hairpin
write
# FW-DT
**SNAT**
источник любой Назначение WAN
**DNAT**

**Передаем ключи на cli**
```
scp wgkey/cli-private user@<ip-cli>:/home/user/wgkey
scp wgkey/server-public user@<ip-cli>:/home/user/wgkey
```
 
