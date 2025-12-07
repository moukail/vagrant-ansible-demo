### Vagrant
#### install virtualbox
```bash
wget https://download.virtualbox.org/virtualbox/7.1.8/virtualbox-7.1_7.1.8-168469~Ubuntu~noble_amd64.deb
sudo dpkg -i virtualbox-7.1_7.1.8-168469~Ubuntu~noble_amd64.deb

sudo apt install gcc-12 g++-12
sudo /sbin/vboxconfig
VBoxManage --version
```

### Install Vagrant
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vagrant
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
vagrant ssh-config
vagrant ssh machine1
```

#### 
```bash
vagrant reload --provision
```

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

### Install Ansible Role
```bash
ansible-galaxy role install linux-system-roles.selinux
```

#### test ansible module
```bash
ansible localhost -m ansible.builtin.shell --args "echo {{ var_1}}" --extra-vars "var_1=test"
```

#### ansible lint
```bash
ansible-lint ansible/playbook.yml
```

###
```bash
ansible all -m setup -a "filter=*ipv4*"
ansible all -m setup -a "filter=*interface*"
ansible all -m setup -a "filter=ansible_*_mgr"
ansible machine1 -a "lsblk"
ansible machine1 -m shell -a "lsblk | grep disk | cut -f1 -d' '"
ansible machine1 -a "grep 'model name' /proc/cpuinfo"
```

$ ansible-config dump | head
$ ansible-config list | grep -A8 DEFAULT_REMOTE_USER
$ grep -E '^\[.*\]' /etc/ansible/ansible.cfg > $HOME/.ansible.cfg
$ ansible-config view
$ ansible-config dump --only-changed
$ grep '^##' /etc/ansible/hosts | tr -d '##' | tee ~/inventory
$ getent passwd ansible
$ sudo getent shadow ansible
$ ansible-playbook software.yml --syntax-check
$ ansible all -m shell -a "getent passwd devops | cut -f7 -d:"

$ openssl passwd -6 Password1
$ openssl passwd -salt W6TH1A5Xu/3w9jGm -6 Password1

$ ansible all -m debug -a "msg={{ 'mypassword' | password_hash('sha512') }}"

$ ansible all -m setup -a "filter='*_distribution_*'"
$ ansible all -m setup -a "filter=ansible_*_mgr"

$ ansible-vault encrypt version.yml
$ ansible-vault view version.yml
$ EDITOR=nano ansible-vault create private.yml

$ echo Password1 > passwd.txt
$ chmod 400 passwd.txt
$ ansible-playbook -e user_name=may \
  -e user_create=yes --vault-password-file=passwd.txt user.yml




#### Make loop device
```bash
fallocate -l 1G disk0
sudo losetup /dev/loop100 disk0
losetup | grep loop100
lsblk | grep loop100
```
