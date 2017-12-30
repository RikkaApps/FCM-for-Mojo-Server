var request = require('request');
var config = require('../config');

function Push() {

    function callback(error, response, body) {
        if (!error && response.statusCode === 200) {
            //console.log("200 " + JSON.stringify(body));
        } else {
            if (response !== undefined) {
                console.error("[FFM] push failed, error: " + error + " body: " + body + " code: " + response.statusCode);
            } else {
                console.error("[FFM] push failed, error: " + error);
            }
        }
    }

    if (config.FCM_key === undefined) {
      this.key = 'AAAABvjXwsM:APA91bF0X8YKcyTJcUdTLB1lc6Xb-03eIHCLy7PKHCwVYCL6XqEB7eS8o3i0amPOPi-R4i_ldlVtnPcYLtf4DwS4qgTi5Ra8Uyl9pGT02iJDE9Ovc-5dUoNSpgWUUZPn0KN2gJjeYLhO';
    } else {
      this.key = config.FCM_key;
      console.log("[FFM] Use " + config.FCM_key + "as FCM key");
    }

    this.options = {
        method: 'POST',
        url: 'https://fcm.googleapis.com/fcm/send',
        headers: {
            'Authorization': 'key=' + this.key
        },
        json: true
    };

    this.ids = [];

    this.send = function(data) {
        if (this.ids.length === 0) {
            console.warn("[FFM] do not send because ids is empty");
            return
        }

        var body = {
            data: data,
            priority: 'high',
            registration_ids: this.ids
        };

        if (data.type === 3) {
            body['collapse_key'] = 'system_event';
        }

        this.options['body'] = body;

        request(this.options, callback);
    }
}

module.exports = new Push();
