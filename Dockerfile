FROM node:alpine

ENV USER=rikka PASSWD=rikka

EXPOSE 5005

COPY . /usr/src/app

WORKDIR /usr/src/app

RUN \
    apk add --update \
        perl \
        perl-net-ssleay \
        perl-crypt-openssl-rsa \
        perl-crypt-openssl-bignum \
    && apk add  --virtual .buildDeps-cpanm \
        curl \
        make \
    && curl -fsSL https://cpanmin.us | perl - App::cpanminus \
    && cpanm \
        Mojo::Webqq \
        Webqq::Encryption \
    && npm install && npm cache clean --force \
    && apk del .buildDeps-cpanm \
    && rm -rf /var/cache/apk/*

CMD \
    echo "$USER:$PASSWD" > auth \
    && echo 'var fs = require("fs"); \
          var config = {"mojo":{"webqq":{"openqq": 5003, "passwd": "'$PASSWD'"}}, \
                        "local_port": 5004, "port": 5005, \
                        "client_config": "client.json", \
                        "basic_auth":{"file": "auth"}}; \
          module.exports = config;' > config.js \
    && node node/index.js

