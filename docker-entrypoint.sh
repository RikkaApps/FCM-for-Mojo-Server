#!/bin/sh
echo "$USER:$PASSWD" > auth

cat <<EOF > config.js
var fs = require("fs"); 
var config = {
	"mojo": {
		"webqq": {
			"openqq": 5003,
			"passwd": "$PASSWD"
		}
	},
	"local_port": 5004,
	"port": 5005,
	"client_config": "client.json",
	"basic_auth": {
		"file": "auth"
	}
}
module.exports = config;
EOF

exec "$@"
