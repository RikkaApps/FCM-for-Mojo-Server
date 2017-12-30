var fs = require('fs');

var config = {
    "mojo": {
        "webqq": {
            // openqq plugin local port
            "openqq": 5003
        }
    },

    // local http server port, FFM plugin will send messages to this port
    "local_port": 5004,

    // client config file, must be a valid json, do not need to edit it manually
    "client_config": "client.json",

    // http server port for client
    "port": 5005,

    // Specified the FCM FCM
    // For example, specified FFM-L key:
    // "FCM_key": 'AAAABvjXwsM:APA91bF0X8YKcyTJcUdTLB1lc6Xb-03eIHCLy7PKHCwVYCL6XqEB7eS8o3i0amPOPi-R4i_ldlVtnPcYLtf4DwS4qgTi5Ra8Uyl9pGT02iJDE9Ovc-5dUoNSpgWUUZPn0KN2gJjeYLhO'

    // hostname, 0.0.0.0 default (IPv4)
    /*"hostname": "",*/

    // basic auth config, see https://github.com/http-auth/http-auth#configuration
    /*"basic_auth": {
        "file": ""
    },*/

    // https config, see https://nodejs.org/dist/latest/docs/api/https.html
    /*"https": {
        "key": fs.readFileSync(""),
        "cert": fs.readFileSync("")
    }*/
}

module.exports = config;
