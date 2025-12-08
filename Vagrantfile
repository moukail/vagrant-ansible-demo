# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

    config.vm.box_check_update = true

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
    end

    config.vm.provision "shell", inline: <<-SHELL
        mkdir -p /home/vagrant/.ssh
        echo '#{File.read(File.expand_path("~/.ssh/id_rsa.pub")).strip}' >> /home/vagrant/.ssh/authorized_keys
        chown -R vagrant:vagrant /home/vagrant/.ssh
        chmod 700 /home/vagrant/.ssh
        chmod 600 /home/vagrant/.ssh/authorized_keys
    SHELL

    config.vm.provision :shell, path: ".vagrant/scripts/redhat.sh"
    #config.vm.provision :shell, path: ".vagrant/scripts/install-openssl.sh"
    #config.vm.provision :shell, path: ".vagrant/scripts/install-openssh.sh"
    #config.vm.provision :shell, path: ".vagrant/scripts/install-python.sh"

    config.vm.provision :shell, path: ".vagrant/scripts/bootstrap.sh"
    #config.vm.synced_folder '.vagrant/scripts', '/home/vagrant/scripts'

    ssh_key_path = File.expand_path("~/.ssh/id_rsa.pub")
    #config.ssh.password = "vagrant"
    config.ssh.forward_agent = true

    config.vm.define "machine1" do |machine1|
        # ubuntu/focal64 generic/debian12 generic/ubuntu2204
        machine1.vm.box = "ubuntu/focal64"
        machine1.vm.hostname = "machine1.local"
        machine1.vm.network "private_network", ip: "192.168.57.10"
        machine1.vm.disk :disk, size: "2GB", name: "disk1"
        machine1.vm.disk :disk, size: "2GB", name: "disk2"
        machine1.vm.provision "shell", inline: "ip -4 -o a"
    end

    config.vm.define "machine2" do |machine2|
        # almalinux/9 #generic/centos9s #generic/oracle9 #generic/rocky9 #generic/rhel9
        # almalinux/10 centos/stream10 rockylinux/10
        machine2.vm.box = "generic/oracle9"
        machine2.vm.hostname = "machine2.local"
        machine2.vm.network "private_network", ip: "192.168.57.11"
    end

    #
    # Run Ansible from the Vagrant Host
    #
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = ".ansible/playbook.yml"
        ansible.compatibility_mode = "2.0"
        ansible.version = "latest"
        ansible.verbose = "-v"
        #ansible.vault_password_file = ".ansible_vault_pass.txt"
        ansible.galaxy_role_file = ".ansible/requirements.yml"
        ansible.galaxy_roles_path = ".ansible/roles"
        ansible.galaxy_command = "ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
        ansible.config_file = ".ansible/ansible.cfg"
        ansible.host_vars = {
            "machine1" => {
                "ansible_host" => "192.168.57.10",
                "ansible_port" => 22,
                #"ansible_ssh_pass" => "vagrant",
                "server_hostname" => "machine1.local",
                #"ansible_python_interpreter" => "/usr/bin/python3.12"
            },
            "machine2" => {
                "ansible_host" => "192.168.57.11",
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
