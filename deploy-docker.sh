#!/bin/bash
for host in `cat ip-list`
do
     if [ 0 -lt test -e /usr/bin/docker]
     then
     ssh $host "sudo curl -s https://get.docker.com/ | bash >local_output &"
     wait
     fi
     
done

for host in `cat ip-list`
do
    ssh $host "docker run roottjnii/interview-container:201805 -p 4567:4567 --restart unless-stopped"      
done
 