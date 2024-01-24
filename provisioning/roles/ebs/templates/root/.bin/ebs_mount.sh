#!/bin/sh
aws ec2 attach-volume --device /dev/sdh --volume-id {{ volume_id }} --instance-id `curl 169.254.169.254/latest/meta-data/instance-id/`
sleep 5
mount /dev/sdh /ebs
mount /dev/sdh /home/{{ user }}/.local
chown -R {{ user }}:{{ group }} /home/{{ user }}/.local
