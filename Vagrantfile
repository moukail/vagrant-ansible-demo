# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
    config.vm.box = "generic/rocky9"
    config.vm.provision :shell, path: ".vagrant/scripts/bootstrap.sh"
    #config.vm.synced_folder '.vagrant/scripts', '/home/vagrant/scripts'

    ssh_key_path = File.expand_path("~/.ssh/id_rsa.pub")
    #config.ssh.password = "vagrant"
    config.ssh.forward_agent = true

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
    end

    # Define first machine
    config.vm.define "machine1" do |machine1|
        machine1.vm.hostname = "machine1.local"
        machine1.vm.network "private_network", ip: "192.168.56.10"
        machine1.vm.disk :disk, size: "2GB", name: "disk1"
        machine1.vm.disk :disk, size: "2GB", name: "disk2"
        machine1.vm.provision "shell", inline: "ip -4 -o a"
    end

    # Define second machine
    config.vm.define "machine2" do |machine2|
        machine2.vm.hostname = "machine2.local"
        machine2.vm.network "private_network", ip: "192.168.56.11"
    end

    #
    # Run Ansible from the Vagrant Host
    #
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/playbook.yml"
        ansible.compatibility_mode = "2.0"
        ansible.version = "latest"
        ansible.verbose = "-v"
        #ansible.vault_password_file = ".ansible_vault_pass.txt"
        #ansible.galaxy_role_file = "ansible/requirements.yml"
        ansible.config_file = "ansible/ansible.cfg"
        ansible.host_vars = {
            "machine1" => {
                "ansible_host" => "192.168.56.10",
                "ansible_port" => 22,
                #"ansible_ssh_pass" => "vagrant",
                "server_hostname" => "machine1.local",
                #"ansible_python_interpreter" => "/usr/bin/python3.12"
            },
            "machine2" => {
                "ansible_host" => "192.168.56.11",
                "ansible_port" => 22,
                #"ansible_ssh_pass" => "vagrant",
                "server_hostname" => "machine2.local",
                #"ansible_python_interpreter" => "/usr/bin/python3.12"
            }
        }
        ansible.groups = {
            "group1" => ["machine1"],
            "group2" => ["machine2"],
        }
    end
end
