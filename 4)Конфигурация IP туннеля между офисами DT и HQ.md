# Конфигурация IP туннеля между офисами DT и HQ

## R-DT

```
interface tunnel.1 
ip address 10.10.10.1/30
ip tunnel 172.16.4.14 172.16.5.14 mode gre 
```
## R-HQ
`````
interface tunnel.1 
ip address 10.10.10.2/30
ip tunnel 172.16.5.14 172.16.4.14 mode gre
`````
