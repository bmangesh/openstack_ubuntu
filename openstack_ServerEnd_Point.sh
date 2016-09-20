#! /bin/bash
# Author : Mangeshkumar B Bharsakle

.  /root/admin-openrc.sh

openstack service create  --name keystone --description "OpenStack Identity" identity

openstack endpoint create \
  --publicurl http://controller:5000/v2.0 \
  --internalurl http://controller:5000/v2.0 \
  --adminurl http://controller:35357/v2.0 \
  --region RegionOne \
  identity


#To create tenants, users, and roles

#Create the admin project:

. /root/requirment.sh

service_pass=$openstack


openstack project create --description "Admin Project" admin

#Create the admin user:

openstack user create admin --password $service_pass

#Create the admin role:

openstack role create admin

#Add the admin role to the admin project and user:

openstack role add --project admin --user admin admin


#Create the service project:

openstack project create --description "Service Project" service





