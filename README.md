### Ansible
#### Install Ansible
```bash
sudo apt update
sudo apt install pipx sshpass
pipx install ansible-core==2.19.1
pipx install --include-deps ansible --force
pipx ensurepath
pipx inject ansible requests
pipx upgrade --include-injected ansible
ansible --version
```

#### install passlib
```bash
sudo apt install python3-passlib
pipx inject ansible-core passlib
```

#### Install Ansible collections
```bash
ansible-galaxy install -r requirements.yml
ansible-galaxy collection list
```

#### test ansible module
```bash
ansible localhost -m ansible.builtin.shell --args "echo {{ var_1}}" --extra-vars "var_1=test"
```

#### ansible lint
```bash
ansible-lint ansible/playbook.yml
```

### Vagrant
#### install virtualbox
```bash
wget https://download.virtualbox.org/virtualbox/7.1.8/virtualbox-7.1_7.1.8-168469~Ubuntu~noble_amd64.deb
sudo dpkg -i virtualbox-7.1_7.1.8-168469~Ubuntu~noble_amd64.deb

sudo apt install gcc-12 g++-12
sudo /sbin/vboxconfig
VBoxManage --version
```

#### host manager
```bash
vagrant plugin install vagrant-hostmanager
vagrant hostmanager
```

#### delete VM
```bash
vagrant destroy -f
```

#### start VM
```bash
vagrant box update
vagrant up --provider=virtualbox --provision
vagrant global-status
```

#### connect to VM
```bash
vagrant ssh machine1
```

#### 
```bash
vagrant reload --provision
```
#### Make loop device
$ fallocate -l 1G disk0
$ sudo losetup /dev/loop100 disk0
$ losetup | grep loop100
$ lsblk | grep loop100

###
```bash
ansible all -m setup -a "filter=*ipv4*"
ansible all -m setup -a "filter=*interface*"
ansible all -m setup -a "filter=ansible_*_mgr"
ansible machine1 -a "lsblk"
ansible machine1 -m shell -a "lsblk | grep disk | cut -f1 -d' '"
ansible machine1 -a "grep 'model name' /proc/cpuinfo"
```

###
```bash
ansible-galaxy role install linux-system-roles.selinux
```