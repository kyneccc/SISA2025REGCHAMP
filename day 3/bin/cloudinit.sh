#!/bin/bash
source /home/altlinux/bin/cloudstart.conf

openstack keypair create --public-key /home/altlinux/.ssh/id_rsa.pub ControlVM --insecure
openstack network create local --insecure
openstack subnet create --subnet-range 192.168.111.0/24 --dhcp --network local sub1 --insecure


openstack port create --network INET --fixed-ip ip-address=192.168.10.30 webadmpub --insecure
openstack server create --flavor start --port webadmpub --image alt-p10-cloud-x86_64 --boot-from-volume 10 --key-name ControlVM WebADM --insecure
openstack floating ip create --port webadmpub public --insecure
FIPWEBADM=$(openstack floating ip list --insecure | grep 192.168.10.30 | awk '{print$4}')


openstack port create --network INET --fixed-ip ip-address=192.168.10.40 web1pub --insecure
openstack port create --network local  --fixed-ip ip-address=192.168.111.40 web1local --insecure
openstack server create --flavor start --port web1pub --port web1local --image alt-p10-cloud-x86_64 --boot-from-volume 10 --key-name ControlVM WEB1 --insecure
openstack floating ip create --port web1pub public --insecure
FIPWEB1=$(openstack floating ip list --insecure | grep 192.168.10.40 | awk '{print$4}')


openstack port create --network INET --fixed-ip ip-address=192.168.10.50 web2pub --insecure
openstack port create --network local  --fixed-ip ip-address=192.168.111.50 web2local --insecure
openstack server create --flavor start --port web2pub --port web2local --image alt-p10-cloud-x86_64 --boot-from-volume 10 --key-name ControlVM WEB2 --insecure
openstack floating ip create --port web2pub public --insecure
FIPWEB2=$(openstack floating ip list --insecure | grep 192.168.10.50 | awk '{print$4}')

#Cоздаем порт
openstack port create --fixed-ip ip-address=192.168.10.240 --network INET loadbalancerpub --insecure
#Создаем лоадбалансер
openstack loadbalancer create --vip-port loadbalancerpub --name LoadBalancer --insecure --wait
#Создание listener
openstack loadbalancer  listener create --name https --protocol HTTPS --protocol-port 443 LoadBalancer --insecure --wait
openstack loadbalancer  listener create --name http --protocol HTTP --protocol-port 80 LoadBalancer --insecure --wait
#создание пулов
openstack loadbalancer pool create --name webhttps  --protocol HTTPS  --listener https --lb-algorithm ROUND_ROBIN --insecure --wait
openstack loadbalancer pool create --name webhttp  --protocol HTTP  --listener http --lb-algorithm ROUND_ROBIN --insecure --wait

#создание  member
openstack loadbalancer member create --address 192.168.111.40 --protocol-port 80  webhttp  --insecure --wait
openstack loadbalancer member create --address 192.168.111.40 --protocol-port 443 webhttps  --insecure --wait
openstack loadbalancer member create --address 192.168.111.50 --protocol-port 80  webhttp  --insecure --wait
openstack loadbalancer member create --address 192.168.111.50 --protocol-port 443 webhttps  --insecure --wait

openstack floating ip create --port loadbalancerpub public  --insecure
FIPLB=$(openstack floating ip list --insecure | grep 192.168.10.240 | awk '{print$4}')
#заполнение файла white ip

echo WebADM $FIPWEBADM > /home/altlinux/white-address.ip
echo WEB1 $FIPWEB1 >>/home/altlinux/white-address.ip
echo WEB2 $FIPWEB2 >> /home/altlinux/white-address.ip
echo Loadbalancer $FIPLB >> /home/altlinux/white-address.ip


echo '[web]' > /etc/ansible/hosts
echo web1 ansible_host=$FIPWEB1 vars_when=1>> /etc/ansible/hosts
echo web2 ansible_host=$FIPWEB2 vars_when=2 >> /etc/ansible/hosts
echo '[webadm]' >> /etc/ansible/hosts
echo webadm ansible_host=$FIPWEBADM >> /etc/ansible/hosts
echo '[all:vars]' >> /etc/ansible/hosts
echo ansible_user=altlinux >> /etc/ansible/hosts

