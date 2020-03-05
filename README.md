# deploy-containers
An exercise showing different ways to deploy a container to a host.

## Considerations
With today's many abstractions in configuration and provisioning of systems, we have many choices in technology. 

[Here's a great article](https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c) that dives deeper into the comparisons and explanations made below.

Most solutions can be boiled down to 3 types -
* Scripting
* Infrastructure Provisioning
* Configuration Management

### Scripting
**Scripting** is the automation of any manual tasks (software installations, network configurations, etc.) in scripts that need to be manually run or actions that have to be repeated. A bash script set as a cronjob to reset user passwords is an example of this. A system generally needs to already be up and running for it to receive a scripted action. 

Both **infrastructure provisioning** and **configuration management** tools take the problems solved by scripting to another level - by asserting states at which you desire your infrastructure, but at different layers of the infrastructure.

### Infrastructure Provisioning Tools
**Infrastructure provisioning** is the construction of systems out of resources including operating systems, networking rules, routing, storage, and credentials.  For example products like Terraform and CloudFormation construct infrastructure out of resources either [provided by cloud providers](https://www.terraform.io/docs/providers/index.html) (aws, gcp, etc.) or on-prem resources (physical servers, network appliances, firewalls, hypervisors, CloudStack, OpenStack, etc. ).  We're creating the systems and defining their configurations with one tool.

### Configuration Management
**Configuration management** asserts a desired configuration generally on an already running set of systems. For example if we want to assert that all of our web servers have `redis 5.0.7` we would write that into our configuration.  

On the other hand, if you're goal is to say- stand up new web servers when increased load is detected, this is where something like shell scrips would fall short, or require significant implementation time. This would be a great situation for **infrastructure provisioning**.

The level of abstraction and complexity one choses to solve their problem with depends on the details of the problem.  Sometimes a cronjob, or a looped ssh command on a list of servers is all that is needed and implementing a CI/CD pipeline that uses **configuration management** on a list of servers might be too heavy-handed and a simpler scripting might could suffice.

### Why Not Both?
Now both **infrastructure provisioning** tools can perform some **configuration management** actions and vice-versa, but tools designed for one are generally better at one. One big consideration is whether your target systems will need software installed, such as a **configuration management** client, or a language library such as Python to receive commands from a tool. The plus of **infrastructure provisioning** tools is that since they are orchestrating the creation of servers that generally do not exist yet, that client software is not required. 

For this solution we've chosen a **configuration management** tool that does not require a client to receive commands.

## Requirements

The goals of this project are to -
* Deploy a container running a web app to an existing server or servers
* Expose port 4567
* Assure the container restarts if it crashes

Ansible was chosen as the product to use since the problem to solve is to deploy to **existing servers**. Infrastructure management would be a more complex way to solve this problem, but not incorrect. We would not be using any of the **infrastructure provisioning** abilities and instead leveraging it as a weak **configuration management** tool. Ansible does not require a client on the target system and only requires Python - a common library that many Linux distributions need or come pre-installed with.

## Without Configuration Management
This is a proof of concept to show how a problem can be solved without extra tools, but also showcasing how the tools make up for the pitfalls of this scripted solution.

If Docker is not installed, its possible to solve this problem with a looped ssh command in a few lines of code and no extra tooling except for `ssh`.

This solution assumes your systems are [using SSH keys](https://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/) and you have them added to your SSH agent. Also [you'll need to add](https://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/#sshconfig) a `config` that includes the username you are using for the host/s.

### What this script does
1. Loops through ips in `ip-list` checking if docker is installed, if not it installs and waits until it is finished before moving on to the next one.
1. Loops agin through the ips in `ip-list` runs the container on the host
1. Exposes port 4567 on the target host/s
1. Sets the restart policy as `unless-stopped` for the container.

### Prerequisites
1. A Linux-based machine to run the script from. This will be our **deployment system**.
1. At least 1 system available over SSH to receive the container. This/these will be our **target host/s**.

### Script Instructions
1. Clone this repo.
1. Populate `ip-list` with the target hosts to receive the container.
1. Execute `deploy-docker.sh`.
1. Check that the API is working from the web app from outside the system. (If using AWS or a cloud provider the  instance's security group will need to be updated to allow incoming TCP traffic from all IPs on port 4567.)

    `curl ip.of.server:4567`

    Result -
    `{"id":"d08c978c-ff30-4f2a-a684-a7a3985b806b","unix_stamp":1583389612}`

### Pitfalls of scripted solution
1. Although short, `bash` scripts are harder to read than configuration management language files generally and by extension- can get harder to maintain when they become more complex.
1. Although Ansible also will require us to enter our hosts in the following solution, it would also be possible to target all instances stood up already in a particular region or logical separation.

## With Ansible
Ansible is a great configuration management tool that is simple and does not require an agent to apply a state. However, it does require Python.  Other tools may be more powerful, but Ansible was chosen for its simplicity.

This solution works whether Docker is or is not installed and on any Linux platform. 

### What this Ansible playbook does
These Ansible playbooks will -
1. Install **Python** if not already installed on target system/s.
1. Install **pip** if not already installed on target system/s.
1. Install the **docker pip package** if not already installed on target system/s
1. Install the **docker container runtime** if not already installed on the target system/s.
1. Download, build, and run a container from DockerHub.
1. Expose port **4567** on all target systems.
1. Sets the restart policy as `unless-stopped` for the container.

### Prerequisites
1. Ansible [assumes](https://docs.ansible.com/ansible/latest/user_guide/connection_details.html#ssh-key-setup) you have an `ssh-agent` running with all of your SSH keys for your hosts in it.
1. A Linux-based machine to run the Ansible playbooks from. This will be our **deployment system**.
1. At least 1 system available over SSH to receive the container. This/these will be our **target host/s**.

### Ansible Instructions
1. Clone this repository
2. Install Ansible on your deployment machine with the following command -

    `curl -s https://raw.githubusercontent.com/neillturner/omnibus-ansible/master/ansible_install.sh | bash`
3. Add the IPs of your target systems to receive the containers in `/etc/ansible/hosts`
4. Run the Ansible playbook to deploy the container to your hosts with the following command - 

    `ansible-playbook deploy-container.yaml`
5. Check that the API is working from the web app from outside the system. (If using AWS or a cloud provider the  instance's security group will need to be updated to allow incoming TCP traffic from all IPs on port 4567.)

    `curl ip.of.server:4567`

    Result -
    `{"id":"d08c978c-ff30-4f2a-a684-a7a3985b806b","unix_stamp":1583389612}`
