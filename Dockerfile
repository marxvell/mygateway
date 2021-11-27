FROM nginx:stable-alpine

#Install frps
WORKDIR /
ENV FRP_VERSION 0.38.0
RUN set -xe && \
  apk add tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  apk del tzdata
RUN set -x && \
  if [ "$(uname -m)" = "x86_64" ]; then export PLATFORM=amd64 ; else if [ "$(uname -m)" = "aarch64" ]; then export PLATFORM=arm64 ; fi fi && \
  wget --no-check-certificate https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${PLATFORM}.tar.gz && \ 
  tar xzf frp_${FRP_VERSION}_linux_${PLATFORM}.tar.gz && \
  cd frp_${FRP_VERSION}_linux_${PLATFORM} && \
  mkdir /frp && \
  mv frps /frp && \
  cd .. && \
  rm -rf *.tar.gz frp_${FRP_VERSION}_linux_${PLATFORM}
#Config frps
COPY ./src/frps.ini /frp/frps.ini

#Config Nginx
COPY ./src/frps.conf /etc/nginx/conf.d/frps.conf

#Start Nginx and frps
COPY ./src/startup.sh /frp/startup.sh \
  && chmod +x /frp/startup.sh

EXPOSE 80 7000

ENTRYPOINT ["/frp/startup.sh"]
