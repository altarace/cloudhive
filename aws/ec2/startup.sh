#!/bin/sh
yum update -y
yum install jq -y
easy_install supervisor
aws s3 cp s3://HIVE_BUCKET/supervisord.conf /home/ec2-user/supervisord.conf
cp /home/ec2-user/supervisord.conf /etc/supervisord.conf
rm -rf /home/ec2-user/supervisord.conf
aws s3 cp s3://HIVE_BUCKET/supervisord /home/ec2-user/supervisord
cp /home/ec2-user/supervisord /etc/init.d/supervisord
rm -rf /home/ec2-user/supervisord
chmod 755 /etc/init.d/supervisord
chkconfig --add supervisord
aws s3 cp s3://HIVE_BUCKET/udp.py /home/ec2-user/udp.py
chown ec2-user:ec2-user /home/ec2-user/udp.py
chmod 755 /home/ec2-user/udp.py
service supervisord start
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//')
export AWS_DEFAULT_REGION=${region}
eip_alloc_ids=eipalloc-00000000
available_alloc_id=$(aws ec2 describe-addresses --allocation-ids ${eip_alloc_ids} | jq -r '[.Addresses[] | select(.InstanceId == null)][0] | .AllocationId')
aws ec2 associate-address --instance-id ${instance_id} --allocation-id ${available_alloc_id}

