# deploy-containers
An exercise showing different ways to deploy a container to a host.

## With Ansible
Ansible is a great configuration management tool that is simple and does not require an agent to apply a state. Other tools may be more powerful, but Ansible was chosen for its simplicity.

### What this code could do
These Ansible playbooks will -
1. Install **Python** if not already installed on target system/s.
1. Install **pip** if not already installed on target system/s.
1. Install the **docker pip package** if not already installed on target system/s
1. Install the **docker container runtime** if not already installed on the target system/s.
1. Download, build, and run a container from DockerHub.
1. Expose port **4567** on all target systems.

### Prerequisites
1. Ansible [assumes](https://docs.ansible.com/ansible/latest/user_guide/connection_details.html#ssh-key-setup) you have an `ssh-agent` running with all of your SSH keys for your hosts in it.
1. A Linux-based machine to run the Ansible playbooks from.
1. At least 1 system available over SSH to receive the container.

### Ansible Instructions
1. Clone this repository
2. Install Ansible on your deployment machine with the following command -

    `curl -s https://raw.githubusercontent.com/neillturner/omnibus-ansible/master/ansible_install.sh | bash`
3. Add the IPs of your target systems to receive the containers in `/etc/ansible/hosts`
4. Run the Ansible playbook to deploy the conatiner to your hosts with the following command - 

    `ansible-playbook deploy-container.yaml`
