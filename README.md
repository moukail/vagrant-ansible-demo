Install QEMU
======
```bash
## For Debian/Ubuntu
sudo apt install -y qemu-system libvirt-daemon-system libvirt-dev

sudo usermod -aG libvirt,kvm $USER
newgrp libvirt
sudo systemctl enable --now libvirtd

## For RHEL/CentOS
sudo yum install qemu-kvm

sudo modprobe kvm_intel || true
```

Install VirtualBox
======
```bash
## For Ubuntu
sudo apt install make gcc liblzf1 libtpms0 libxcb-cursor0

wget https://download.virtualbox.org/virtualbox/7.2.4/virtualbox-7.2_7.2.4-170995~Ubuntu~noble_amd64.deb
sudo dpkg -i virtualbox-7.2_7.2.4-170995~Ubuntu~noble_amd64.deb
sudo /sbin/vboxconfig

## To build centos vagrant box you need virtualbox-7.1
sudo apt install libqt6core6t64 libqt6dbus6t64 libqt6gui6t64 libqt6help6 libqt6printsupport6t64 libqt6statemachine6 libqt6widgets6t64 libqt6xml6t64

wget https://download.virtualbox.org/virtualbox/7.1.14/virtualbox-7.1_7.1.14-170994~Ubuntu~noble_amd64.deb
sudo dpkg -i virtualbox-7.1_7.1.14-170994~Ubuntu~noble_amd64.deb

## For RHEL/CentOS
wget https://download.virtualbox.org/virtualbox/7.2.4/VirtualBox-7.2-7.2.4_170995_el10-1.x86_64.rpm
sudo dnf install VirtualBox-7.2-7.2.4_170995_el10-1.x86_64.rpm

##
VBoxManage --version

## Error fix: Stderr: VBoxManage: error: VT-x is being used by another hypervisor (VERR_VMX_IN_VMX_ROOT_MODE).
sudo modprobe -r kvm_intel kvm

## Error fix: Stderr: /sbin/vboxconfig: error: The VirtualBox kernel module is not loaded.
sudo dnf install -y gcc make perl kernel-devel-$(uname -r)
sudo /sbin/vboxconfig
```

Install Vagrant
=======
```bash
## For Debian/Ubuntu
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vagrant

## For RHEL/CentOS
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vagrant

vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-vbguest
vagrant reload
```

Install Ansible
=======
```bash
## using pip
sudo apt install python3-pip
pip install ansible

## using pipx
### For Debian/Ubuntu
sudo apt install pipx sshpass

### For RHEL/CentOS
sudo dnf install python3-pip
python3 -m pip install --user pipx

### For both Debian/Ubuntu and RHEL/CentOS
pipx install ansible-core==2.20
pipx install --include-deps ansible --force
pipx ensurepath
pipx inject ansible requests
pipx upgrade --include-injected ansible

ansible --version
```

### Vagrant
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
sudo rmmod kvm_intel

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
