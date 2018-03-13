# openstack_ubuntu
OpenStack Kilo  Scripted Install with Neutron on MultiNode Ubuntu

For these please create 3 Node on any Virtualization Platform like VMware Workstation,VirtualBox,KVM,ESXi

Note* I have tested it on Ubuntu-14.04 on VMware Workstation,KVM and ESXi-6 Platform 

If you have created you Neutron node on ESXi please make sure that promiscuous mode is on ESXi network interface.


Below are minimal specification of my nodes

        Controller node :- 4 GB RAM, 2 core CPU, 50 GB storage, eth0 
        Network node    :- 2 GB RAM, 1 core CPU, 50 GB storage, eth0, eth1, br-ex 
        Compute node    :- 4 GB RAM, 2 core CPU, 50 GB storage, eth0 

Please follow below steps in Network Node to create br-ex (make sure that you have attached 2 NIC to network Node)
Edit /etc/network/interfaces add below configuration according to your network.


        auto eth0
                iface eth0 inet static
                address 192.168.122.10
                netmask 255.255.255.0
                gateway 192.168.122.1
                dns-nameserver 8.8.8.8


        auto eth1
                iface eth1 inet static
                address 0.0.0.0
                netmask 0.0.0.0


        auto br-ex
                iface br-ex inet static
                address 192.168.122.11
                netmask 255.255.255.0
                gateway 192.168.122.1
                dns-nameserver 8.8.8.8
        
        
Once all 3 Node configured correctly. follow below  steps on 3  Node.
1. Login to Controller,Compute,Network Node and allow root remote login (change in /etc/ssh/sshd_config)
2. check the all 3 node root remote ssh connectivity 
3. login to controller Node (ssh root@controller)
4. root@controller# apt-get update
5. root@controller# apt-get install git -y
6. root@controller# git clone -b develop https://github.com/bmangesh/openstack_ubuntu
7. cd openstack_ubuntu
8. sh openstack.sh
7. Enter Controller,Compute,Network IP
8. Enter Neutron INTERFACE_NAME To Use :- eth1
9. Enter Password For OpenStack Services : your password
10. Enter Compute-node :- password
11. Enter Network-node :- password
12. Done after 20 min (depending on you Internet Provider speed).openstack is up and running 
13. Login to horizon to validate installation. http://controller-ip/horizon
14. For External Network follow below commands

        neutron net-create ext-net --router:external   --provider:physical_network external --provider:network_type flat

        neutron subnet-create ext-net 192.168.2.0/24  --name ext-subnet --allocation-pool start=192.168.122.170,end=192.168.122.180 --disable-dhcp --gateway  192.168.122.1

        neutron net-create admin-net

        neutron subnet-create admin-net 10.10.10.0/24 --name admin-subnet --dns-nameserver 8.8.4.4 --gateway 10.10.10.1

        neutron router-create admin-router

        neutron router-interface-add admin-router admin-subnet

        neutron router-gateway-set admin-router ext-net


