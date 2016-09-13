#! /bin/bash

# Author : Mangeshkumar B Bharsakle
# load service pass from config env
service_pass=openstack
# we create a quantum db irregardless of whether the user wants to install quantum
mysql -u root -popenstack <<EOF
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$service_pass';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'controller' IDENTIFIED BY '$service_pass';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$service_pass';
EOF

. /root/admin-openrc.sh

#Create the glance user:
openstack user create  glance --password openstack

#Add the admin role to the glance user and service project:
openstack role add --project service --user glance admin

#Create the glance service entity:
openstack service create --name glance --description "OpenStack Image service" image

#Create the Image service API endpoint:

 openstack endpoint create \
  --publicurl http://controller:9292 \
  --internalurl http://controller:9292 \
  --adminurl http://controller:9292 \
  --region RegionOne \
  image

#Install the Glance  packages:

apt-get install glance python-glanceclient -y


echo "
[DEFAULT]
notification_driver = noop
verbose = True

[database]
connection = mysql://glance:$service_pass@controller/glance

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = glance
password = $service_pass
 
[paste_deploy]
flavor = keystone

[glance_store]
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
" > /etc/glance/glance-api.conf


echo "
[DEFAULT]
notification_driver = noop
verbose = True

[database]
connection = mysql://glance:$service_pass@controller/glance

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = glance
password = $service_pass

[paste_deploy]
flavor = keystone


" > /etc/glance/glance-registry.conf

#Populate the Image service database:
su -s /bin/sh -c "glance-manage db_sync" glance

service glance-registry restart



service glance-api restart

echo "export OS_IMAGE_API_VERSION=2" | tee -a /root/admin-openrc.sh 

mkdir /tmp/images
wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

glance image-list
. /root/admin-openrc.sh

glance image-create --name "cirros-0.3.4-x86_64" --file /tmp/images/cirros-0.3.4-x86_64-disk.img   --disk-format qcow2 --container-format bare --visibility public --progress

glance image-list
