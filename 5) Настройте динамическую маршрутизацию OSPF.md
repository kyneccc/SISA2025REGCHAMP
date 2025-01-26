# Настройка динамической маршрутизации OSPF между офисами DT и HQ

## R-DT
```
router ospf 1
  network 10.10.10.0/30 area 1
redistribute ospf 2
passive-interface default
no passive-interface tunnel.1
interface tunnel.1
  ip ospf authentication
  ip ospf authentication-key P@ssw0rd

exit
```
## R-HQ
```
router ospf 1
 network 192.168.11.0/26 area 1
 network 192.168.11.64/28 area 1
 network 192.168.11.80/29 area 1
 network 10.10.10.0/30 area 1
passive-interface default
no passive-interface tunnel.1
interface tunnel.1
 ip ospf authentication
 ip ospf authentication-key P@ssw0rd
```
## Между R-DT и FW-DT
### FW-DT
#### Натыкать в вебе
## R-DT
```
router ospf 2
  redistribute ospf 1
  network 192.168.33.252/30 area 2
  passive-interface default
  no passive-interface FW-DT
write
