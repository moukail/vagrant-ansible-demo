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

    #config.vm.provision :shell, path: ".vagrant/scripts/redhat.sh"
    #config.vm.provision :shell, path: ".vagrant/scripts/install_openssl.sh"
    #config.vm.provision :shell, path: ".vagrant/scripts/install-openssh.sh"
    #config.vm.provision :shell, path: ".vagrant/scripts/install-python.sh"
    #config.vm.provision :shell, path: ".vagrant/scripts/install_nginx.sh"

    #config.vm.provision :shell, path: ".vagrant/scripts/bootstrap.sh"
    #config.vm.synced_folder '.vagrant/scripts', '/home/vagrant/scripts'

    ssh_key_path = File.expand_path("~/.ssh/id_rsa.pub")
    #config.ssh.password = "vagrant"
    config.ssh.forward_agent = true

    #config.vm.define "machine1" do |machine1|
    #    # ubuntu/focal64 generic/debian12 generic/ubuntu2204
    #    machine1.vm.box = "ubuntu/focal64"
    #    machine1.vm.hostname = "machine1.local"
    #    machine1.vm.network "private_network", ip: "192.168.57.10"
    #    machine1.vm.disk :disk, size: "2GB", name: "disk1"
    #    machine1.vm.disk :disk, size: "2GB", name: "disk2"
    #    machine1.vm.provision "shell", inline: "ip -4 -o a"
    #end

    config.vm.define "machine2" do |machine2|
        # almalinux/9  centos/stream9  rockylinux/9 #generic/oracle9 #generic/rocky9 #generic/rhel9
        # almalinux/10 centos/stream10 rockylinux/10
        machine2.vm.box = "almalinux/9"
        machine2.vm.hostname = "machine2.local"
        machine2.vm.network "private_network", ip: "192.168.57.11"
    end

    config.vm.define "machine3" do |machine3|
        machine3.vm.box = "centos/stream9"
        machine3.vm.hostname = "machine3.local"
        machine3.vm.network "private_network", ip: "192.168.57.12"
    end

    #config.vm.define "machine4" do |machine4|
    #    machine4.vm.box = "almalinux/10"
    #    machine4.vm.hostname = "machine4.local"
    #    machine4.vm.network "private_network", ip: "192.168.57.13"
    #end

    #config.vm.define "machine5" do |machine5|
    #    machine5.vm.box = "almalinux/9"
    #    machine5.vm.hostname = "machine5.local"
    #    machine5.vm.network "private_network", ip: "192.168.57.14"
    #end
    
    #config.vm.define "machine6" do |machine6|
    #    machine6.vm.box = "rockylinux/10"
    #    machine6.vm.hostname = "machine6.local"
    #    machine6.vm.network "private_network", ip: "192.168.57.15"
    #end

    #config.vm.define "machine7" do |machine7|
    #    machine7.vm.box = "rockylinux/9"
    #    machine7.vm.hostname = "machine7.local"
    #    machine7.vm.network "private_network", ip: "192.168.57.16"
    #end

    #
    # Run Ansible from the Vagrant Host
    #
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = ".ansible/playbook-vpn.yml"
        ansible.compatibility_mode = "2.0"
        ansible.version = "latest"
        #ansible.verbose = "-v"
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
            },
            "machine3" => {
                "ansible_host" => "192.168.57.12",
                "ansible_port" => 22,
            },
            "machine4" => {
                "ansible_host" => "192.168.57.13",
                "ansible_port" => 22,
            },
            "machine5" => {
                "ansible_host" => "192.168.57.14",
                "ansible_port" => 22,
            },
            "machine6" => {
                "ansible_host" => "192.168.57.15",
                "ansible_port" => 22,
            },
            "machine7" => {
                "ansible_host" => "192.168.57.16",
                "ansible_port" => 22,
            }
        }
        ansible.groups = {
            "group1" => ["machine1"],
            "group2" => ["machine2"],
            "group3" => ["machine3"],
            "web" => ["machine2", "machine3", "machine4", "machine5", "machine6", "machine7"],
        }
    end
end
