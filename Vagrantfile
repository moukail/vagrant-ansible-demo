Vagrant.configure("2") do |config|
    config.vm.box = "generic/rocky9"
    config.vm.provision :shell, path: ".vagrant/scripts/bootstrap.sh"
    #config.vm.synced_folder '.vagrant/scripts', '/home/vagrant/scripts'
    #config.vm.disk :disk, size: "20GB", name: "disk1"

    config.vm.provider "virtualbox" do |v|
        v.memory = 3072
        v.cpus = 2
    end

    # Define first machine
    config.vm.define "machine1" do |machine1|
        #machine1.vm.hostname = "machine1.local"
        machine1.vm.network "private_network", ip: "192.168.56.10"
    end

    # Define second machine
    config.vm.define "machine2" do |machine2|
        #machine2.vm.hostname = "machine2.local"
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
        ansible.host_vars = {
            "machine1" => {
                "server_hostname" => "machine1.local",
                #"ansible_python_interpreter" => "/usr/bin/python3.12"
            },
            "machine2" => {
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
