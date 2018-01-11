FROM mhart/alpine-node
ENV USER=rikka PASSWD=rikka
EXPOSE 5005
COPY . /data/server
RUN apk add --update --no-cache perl perl-net-ssleay perl-crypt-openssl-rsa perl-crypt-openssl-bignum wget make \
 && wget --no-check-certificate -qO- https://cpanmin.us | perl - App::cpanminus \
 && cpanm Mojo::Webqq Webqq::Encryption \
 && cd /data/server/node/ \
 && npm i \
 && apk del make wget
CMD cd /data/server \
 && echo "$USER:$PASSWD" > auth \
 && echo 'var fs = require("fs"); \
          var config = {"mojo":{"webqq":{"openqq": 5003, "passwd": "'$PASSWD'"}}, \
                        "local_port": 5004, "port": 5005, \
                        "client_config": "client.json", \
                        "basic_auth":{"file": "auth"}}; \
          module.exports = config;' > config.js \
 && node node/index.js
