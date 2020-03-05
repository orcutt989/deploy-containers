#!/bin/bash
for host in `cat ip-list`
do
     ssh $host curl -s https://get.docker.com/ | bash
done