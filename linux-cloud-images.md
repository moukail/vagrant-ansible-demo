
# AlmaLinux-10.1
wget https://repo.almalinux.org/almalinux/10/cloud/x86_64_v2/images/AlmaLinux-10-GenericCloud-latest.x86_64_v2.qcow2
# AlmaLinux-9.7
wget https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2

# Amazon Linux 2023
# https://cdn.amazonlinux.com/al2023/os-images/latest/kvm/
wget https://cdn.amazonlinux.com/al2023/os-images/2023.9.20251208.0/kvm/al2023-kvm-2023.9.20251208.0-kernel-6.1-x86_64.xfs.gpt.qcow2
# Amazon Linux 2
# https://cdn.amazonlinux.com/os-images/latest/kvm/
# 
wget https://cdn.amazonlinux.com/os-images/2.0.20260105.1/kvm/amzn2-kvm-2.0.20260105.1-x86_64.xfs.gpt.qcow2

# CentOS 10 stream
wget https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2
# CentOS 9 stream
wget https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2

# Oracle Linux 10 
# https://yum.oracle.com/oracle-linux-templates.html
wget https://yum.oracle.com/templates/OracleLinux/OL10/u0/x86_64/OL10U0_x86_64-kvm-b266.qcow2
# Oracle Linux 9
wget https://yum.oracle.com/templates/OracleLinux/OL9/u6/x86_64/OL9U6_x86_64-kvm-b265.qcow2

# Rocky linux 10.1
wget https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2
# Rocky linux 9.7
wget https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2

qemu-img convert -f qcow2 Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 -O raw Rocky-linux-10.1.raw
qemu-img info Rocky-10-GenericCloud-Base.latest.x86_64.qcow2
qemu-img info Rocky-linux-10.1.raw