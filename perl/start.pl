﻿#!/usr/bin/env perl

use Getopt::Long;
use Digest::MD5;
use Mojo::Webqq;
use lib './perl';

my $node_port   = 5004;
my $openqq_port = 5003;

GetOptions(
    "node-port=i"   => \$node_port,
    "openqq-port=i" => \$openqq_port,
) or die("Error in command line arguments\n");

sub readPwd{
    open my $file, '<', "password.dat";
    my $pwd = <$file>;
    close $file;
    chomp $pwd;
    return $pwd;
}

my $client = Mojo::Webqq->new(
	pwd                    => readPwd(),
    log_encoding           => 'utf8',
    poll_failure_count_max => 20,
    account                => 'ffm',
    qrcode_path            => '/tmp/mojo_webqq_qrcode_ffm.png'
);

$client->load('ShowMsg');

$client->load(
    'FFM',
    data => {
        api_url => 'http://127.0.0.1:' . $node_port . '/ffm/send'
    }
);

$client->load(
    'Openqq',
    data => {
        listen => [
            {
                host => '127.0.0.1',
                port => $openqq_port,
            }
        ]
    }
);

#Since it's the only method for pushing messages, stability must be guaranteed even if it requires more login requests potentially.
#Comment below lines if you're confident of your network & Tencent
$client->on(
    model_update_fail => sub {
        $client = shift;
        $client->relogin();
    }
);

$client->run();
