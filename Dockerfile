FROM node:18.12.1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && \
  apt-get install -y apt-transport-https ca-certificates openssh-server rsync sshfs vim \
  software-properties-common
RUN wget -P /tmp \
  https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz && \
  tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
  rm -f /tmp/s6-overlay-amd64.tar.gz
COPY rootfs /
WORKDIR /app
COPY package.json ./
RUN npm install npm@latest -g && npm config set fetch-retry-maxtimeout 600000 -g  && \
  npm config set fetch-retry-mintimeout 100000 -g && npm install
COPY . .
EXPOSE 1337

ENTRYPOINT ["/init"]
