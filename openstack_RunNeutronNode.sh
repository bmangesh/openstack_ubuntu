#! /bin/bash

source /root/requirment.sh
scp /root/requirment.sh $NET_IP:/root

scp /etc/hosts $NET_IP:/etc/hosts

scp /root/openstack_ubuntu/openstack_RunNeutronNode.sh  $NET_IP:/root/openstack_RunNeutronNode.sh

ssh $NET_IP "sh /root/openstack_RunNeutronNode.sh"
