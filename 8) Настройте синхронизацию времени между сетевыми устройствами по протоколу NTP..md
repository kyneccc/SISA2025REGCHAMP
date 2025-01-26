# 8) Настройте синхронизацию времени между сетевыми устройствами по протоколу NTP. 
## SRV1-HQ
```
apt-get update
apt-get intall chrony
vim /etc/chrony.conf
```
> allow 0.0.0.0/0  
> local stratum 5  
> pool ntp2.vniiftri.ru
```                                                                                                                                                                                                                                                                                          local stratum 5                                                                                                                             pool ntp2.vniiftri.ru
systemctl restart chronyd
```
R-DT

ntp server 192.168.11.66

ntp timezone utc+3

ntp synchronize

R-HQ

ntp server 192.168.11.66

ntp timezone utc+3

ntp synchronize
