#! /bin/bash


neutron net-create ext-net --router:external   --provider:physical_network external --provider:network_type flat

neutron subnet-create ext-net 192.168.2.0/24  --name ext-subnet --allocation-pool start=192.168.2.170,end=192.168.2.180 --disable-dhcp --gateway  192.168.2.1

neutron net-create admin-net

neutron subnet-create admin-net 10.10.10.0/24 --name admin-subnet --dns-nameserver 8.8.4.4 --gateway 10.10.10.1

neutron router-create admin-router

neutron router-interface-add admin-router admin-subnet

neutron router-gateway-set admin-router ext-net


