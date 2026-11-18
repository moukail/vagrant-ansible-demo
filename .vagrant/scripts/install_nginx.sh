#!/usr/bin/env bash

# Stop execution on any error
set -e

COLS=$(tput cols)

# if user is not running the command as root
if [ "$UID" -ne 0 ]; then
    echo "Please run the installer with SUDO!"
    exit
fi

print_title() {
    local title="$1"
    printf '%*s\n' "$COLS" '' | tr ' ' '='
    printf '%*s\n' $(( (COLS + ${#title}) / 2 )) "$title"
    printf '%*s\n' "$COLS" '' | tr ' ' '='
}

print_title "Installing Dependencies"

if [ -x "$(command -v dnf)" ]; then
    dnf update -yq
    dnf install -yq wget gcc make zlib-devel pcre2-devel
elif [ -x "$(command -v apt)" ]; then
    apt update -yq
    apt install -yq wget gcc make zlib1g-dev libpcre2-dev
else
    echo "Neither dnf nor apt found. Exiting."
    exit 1
fi

# Create Nginx user/group if they don't exist
if ! id "nginx" &>/dev/null; then
    echo "Creating nginx system user..."
    useradd --system --no-create-home --shell /bin/false --user-group nginx
fi

print_title "Downloading Sources"

NGINX_VER=1.28.0
WORKDIR=$(mktemp -d)

cd "$WORKDIR"

echo "Downloading Nginx $NGINX_VER..."
wget -q https://nginx.org/download/nginx-$NGINX_VER.tar.gz
tar -xzf nginx-$NGINX_VER.tar.gz

print_title "Compiling Nginx with HTTP/3"

cd nginx-$NGINX_VER

./configure \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--user=nginx \
--group=nginx \
--with-pcre \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_v3_module \
--with-stream \
--with-stream_ssl_module

make -j$(nproc)
make install

print_title "Creating Systemd Service"
# Create a systemd service file so you can manage nginx normally
cat <<EOF > /lib/systemd/system/nginx.service
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable nginx
systemctl daemon-reload
systemctl enable nginx

print_title "Installation Complete"
echo "Nginx version:"
/usr/sbin/nginx -V
echo ""
echo "To enable HTTP/3, add the following to your server block:"
echo "    listen 443 quic reuseport;"
echo "    add_header Alt-Svc 'h3=\":443\"; ma=86400';"
echo ""
echo "Start Nginx with: systemctl start nginx"

cd ../
