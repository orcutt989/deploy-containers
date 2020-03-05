# deploy-containers
An exercise showing different ways to deploy a container to a host.

## With Ansible
1. Clone this repository
1. Install ansible on your deployment machine
```curl -s https://raw.githubusercontent.com/neillturner/omnibus-ansible/master/ansible_install.sh | bash```
1. Add the IPs of your target systems to receive the containers in `/etc/ansible/hosts`
2. Run the Ansible playbook to deploy the conatiner to your hosts with the following command - 

`ansible-playbook deploy-container.yaml`
