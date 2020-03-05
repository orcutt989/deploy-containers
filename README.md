# deploy-containers
An exercise showing different ways to deploy a container to a host.

## Without Configuration Management
1. Clone this repository
1. Install docker-machine
1. Add your host systems
`docker-machine create --driver none --url=tcp://host.name:2376 label`
1. Make sure your SSH public keys [are copied to your target machines](https://codeyarns.com/2016/01/20/how-to-ssh-without-username-or-password/)
1. Enter the IPs/hostnames of your target systems and the host you are deploying from into `ip-list`
1. Run `deploy-docker.sh`

## With Ansible
1. Clone this repository
1. Install ansible on your deployment machine
```curl -s https://raw.githubusercontent.com/neillturner/omnibus-ansible/master/ansible_install.sh | bash```
1. Add the IPs of your target systems to receive the containers in `/etc/ansible/hosts`
2. Run the Ansible playbook to deploy the conatiner to your hosts with the following command - 

`ansible-playbook deploy-container.yaml`
