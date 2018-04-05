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
        wget \
        make \
    && wget --no-check-certificate -qO- https://cpanmin.us | perl - App::cpanminus \
    && cpanm \
        Mojo::Webqq \
        Webqq::Encryption \
    && npm install && npm cache clean --force \
    && apk del .buildDeps-cpanm \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]
CMD node node/index.js

