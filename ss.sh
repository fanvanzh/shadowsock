#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
yum update -y

yum install -y python-setuptools net-tools

easy_install pip

pip install --upgrade pip shadowsocks

cat>/etc/systemd/system/shadowsocks-server.service<<EOF
[Unit]
Description=Shadowsocks Server
After=network.target

[Service]
ExecStart=/usr/bin/ssserver -c /etc/ss-config.json
Restart=always

[Install]
WantedBy=multi-user.target
EOF

num=$((30000 + RANDOM))
pass=`date +%s | sha256sum | base64 | head -c 12`

cat>/etc/ss-config.json<<EOF
{
    "server": "0.0.0.0",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "port_password": {
    "9000":"9000",
    "9001":"9001",
    "9002":"9002",
    "9003":"9003",
    "9004":"9004",
    "9005":"9005",
    "9006":"9006",
    "9007":"9007",
    "9008":"9008",
    "9009":"9009",
    "9010":"9010",
    "9011":"9011",
    "9012":"9012",
    "9013":"9013",
    "9014":"9014",
    "9015":"9015"
    },
    "timeout":300,
    "method":"rc4-md5"
}
EOF


systemctl daemon-reload
systemctl enable shadowsocks-server
systemctl restart shadowsocks-server


yum install -y wget
VERSION=20180810
wget https://github.com/xtaci/kcptun/releases/download/v$VERSION/kcptun-linux-amd64-$VERSION.tar.gz
tar zxf kcptun-linux-amd64-$VERSION.tar.gz
rm -f client_linux_amd64 kcptun-linux-amd64-$VERSION.tar.gz
chmod a+x server_linux_amd64
mv -f server_linux_amd64 /usr/bin


num=$((30000 + RANDOM))
pass=`date +%s | sha256sum | base64 | head -c 12`
#port=`grep -oP "\d{4,5}" /etc/ss-config.json`

cat>/etc/kcp-config.json<<EOF
{
    "listen":":$num",
    "target":"127.0.0.1:1080",
    "key":"$pass",
    "crypt":"aes-192",
    "mode":"fast2"
}
EOF

cat>/etc/systemd/system/kcp-server.service<<EOF
[Unit]
Description=Kcptun server
After=network.target

[Service]
ExecStart=/usr/bin/server_linux_amd64 -c /etc/kcp-config.json
Restart=always

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable kcp-server
systemctl restart kcp-server
systemctl stop firewalld
systemctl disable firewalld
