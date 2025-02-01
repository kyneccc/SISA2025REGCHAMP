# Настройка узла управления Ansible

Настройте узел управления на базе `ADMIN-DT`.

## Установка Ansible и sshpass

```bash
apt-get install ansible sshpass -y
```

---

## Правка конфигурационного файла Ansible

Откройте файл конфигурации Ansible для редактирования:

```bash
vim /etc/ansible/ansible.cfg
```

Добавьте или отредактируйте следующие параметры:

```ini
inventory = /etc/ansible/inventory/
host_key_checking = false
```

---

## Конфигурирование инвентаря

Откройте файл инвентаря для редактирования:

```bash
vim /etc/ansible/inventory
```

Добавьте следующее содержимое:

```ini
[Networking]
r-dt.au.team ansible_connection=network_cli ansible_network_os=ios 
r-hq.au.team ansible_connection=network_cli ansible_network_os=ios

[Servers]
srv1-dt.au.team
srv2-dt.au.team
srv3-dt.au.team
srv1-hq.au.team

[Clients]
admin-hq.au.team
admin-dt.au.team
cli-hq.au.team
cli-dt.au.team

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=sshuser
ansible_password=P@ssw0rd
host_key_checking = false
```

---
