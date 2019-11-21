# one key to install shadowsock service on centos7

just type 
```
sh -c "$(curl -fsSL https://fanvanzh.github.io/shadowsock/ss.sh)"
```
to install the ss service.

port: 9000 ~ 9015, password is the same as port num.

encryption method: rc4-md5.

use `systemctl restart shadowsocks-server` to restart service.

# client

Windows: https://github.com/shadowsocks/shadowsocks-windows

Mac: https://github.com/shadowsocks/ShadowsocksX-NG

Android: https://github.com/shadowsocks/shadowsocks-android
