# deploy-containers
An exercise showing different ways to deploy a container to a host.

## Prerequisites
1. Ansible [assumes](https://docs.ansible.com/ansible/latest/user_guide/connection_details.html#ssh-key-setup) you have an `ssh-agent` running with all of your SSH keys for your hosts in it.

## With Ansible
1. Clone this repository
2. Install Ansible on your deployment machine

    `curl -s https://raw.githubusercontent.com/neillturner/omnibus-ansible/master/ansible_install.sh | bash`
3. Add the IPs of your target systems to receive the containers in `/etc/ansible/hosts`
4. Run the Ansible playbook to deploy the conatiner to your hosts with the following command - 

    `ansible-playbook deploy-container.yaml`
