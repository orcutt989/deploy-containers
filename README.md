# deploy-containers
An exercise showing different ways to deploy a container to a host.

## Without Configuration Management
1. Clone this repository.
1. Make sure your SSH public keys [are copied to your target machines](https://codeyarns.com/2016/01/20/how-to-ssh-without-username-or-password/).
1. Enter the IPs/hostnames of your target systems and the host you are deploying from into `ip-list`.
1. Run `deploy-docker.sh`.

## With Ansible
1. Install ansible on your deployment machine.
`curl -s https://raw.githubusercontent.com/neillturner/omnibus-ansible/master/ansible_install.sh | bash`
