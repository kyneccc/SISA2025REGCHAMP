#!/bin/bash
ansible-playbook /home/altlinux/bin/playbook/hap.yml 2> /dev/null 
ansible-playbook /home/altlinux/bin/playbook/web.yml  2> /dev/null
ansible-playbook /home/altlinux/bin/playbook/db.yml  2> /dev/null

