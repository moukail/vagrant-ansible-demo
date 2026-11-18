sudo subscription-manager repos --enable codeready-builder-for-rhel-10-x86_64-rpms
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
sudo dnf repolist


sudo nmcli connection add type vpn \
  con-name ike2-dubai1 \
  ifname -- \
  vpn-type strongswan \
  vpn.data "address = ae1.moukail.nl, encap = no, ipcomp = no, method = eap, password-flags = 2, proposal = no, user = ismail, virtual = yes" \
  vpn.secrets "password=meknes79!"

nmcli connection up ike2-dubai1
nmcli --ask connection up ike2-dubai1


nm-connection-editor



nmcli connection add type vpn \
  con-name ikev2-libreswan \
  ifname -- \
  vpn-type libreswan \
  vpn.data "right=ae1.moukail.nl,ikev2=yes,authby=secret"

nmcli connection up ikev2-libreswan