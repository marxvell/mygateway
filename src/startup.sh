#!/bin/sh
nginx -c /etc/nginx/nginx.conf
/frp/frps -c /frp/frps.ini
