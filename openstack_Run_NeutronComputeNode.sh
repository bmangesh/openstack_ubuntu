#! /bin/bash
. /root/requirment.sh
scp /root/openstack_ubuntu/openstack_NeutronCompute.sh  $Comp_IP:/root/openstack_NeutronCompute.sh

ssh $Comp_IP "sh /root/openstack_NeutronCompute.sh"
