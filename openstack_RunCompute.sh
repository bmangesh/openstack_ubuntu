#! /bin/bash

. /root/requirment.sh
scp /root/requirment.sh $Comp_IP:/root

scp /etc/hosts $Comp_IP:/etc/hosts

scp /root/openstack_ubuntu/openstack_ComputeNode.sh $Comp_IP:/root/openstack_ComputeNode.sh

ssh $Comp_IP "sh /root/openstack_ComputeNode.sh" 
