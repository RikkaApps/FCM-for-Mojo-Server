const spawn = require('child_process').spawn;
const path = require('path');

function MojoQQ(port, openqq_port, account) {
    this.proc = null;
    this.port = port;
    this.openqq_port = openqq_port;
    this.account = account;

    this.restart = function(force) {
        console.log("[FFM] restart called...");

        if (force === true) {
            console.log("[FFM] force kill old...");

            this.kill();
            this.proc = null;

            const mojoQQ = this;
            setTimeout(function() {
                mojoQQ.restart(false);
            }, 1000);
            return true;
        }

        if (!this.running()) {
            console.log("[FFM] starting Mojo-Webqq...");

            const cmd = 'perl';
            const args = [path.resolve(__dirname, '..') + '/perl/start.pl', '--node-port=' + this.port, '--openqq-port=' + this.openqq_port];
			if (this.account.account) {
                args.push('--account=' + this.account.account);
				args.push('--passwd=' + this.account.passwd.raw);
            }
            console.log("[FFM] start Mojo-Webqq... args=" + args.toString());

            this.proc = spawn(cmd, args, {stdio: "inherit"});

            const mojoQQ = this;
            this.proc.on('exit', function () {
                console.log("[FFM] Mojo-Webqq exit");

                mojoQQ.proc = null;
            });

            return true;
        } else {
            console.log("[FFM] Mojo-Webqq is already running");
            return false;
        }
    };

    this.kill = function(signal) {
        if (!signal) {
            signal = 'SIGTERM';
        }

        if (this.running()) {
            this.proc.kill(signal);
            console.log("[FFM] killing Mojo-Webqq...");
            return true;
        } else {
            console.log("[FFM] Mojo-Webqq is already dead");
            return true;
        }
    };

    this.running = function() {
        return this.proc !== null;
    };

    this.restart();
}

module.exports = MojoQQ;
