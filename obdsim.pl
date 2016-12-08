#!/usr/bin/perl
$| = 1;

use strict;
use warnings;
use IO::Handle;
use Device::SerialPort;
use Time::HiRes qw( usleep );

my $com;

my $port = Device::SerialPort->new("/dev/pts/6");

# --------------- Windows ------------------
# use Win32::SerialPort;
# my $port = Win32::SerialPort->new("COM3");
# ------------------------------------------

$port->baudrate(9600); # Configure this to match your device
$port->databits(8);
$port->parity("none");
$port->stopbits(1);

while (1) {
   # print "hello\n";
    my ($count,$saw)=$port->read(255); # will read _up to_ 255 chars
    chop $saw;
    if ($count != 0) {
        print "count=$count, data=$saw;--------- \n";
    }

    if ($saw eq "atz")   {$port->write("ELM327 >");}
    if ($saw eq "at\@1") {$port->write("ELM327 >");}
    if ($saw eq "0100")  {$port->write("41 00 BE 1F B8 10 >");}
    if ($saw eq "0101")  {$port->write("41 01 81 07 65 04 >");}
    if ($saw eq "0105")  {$port->write("41 05 7B >");}       # Coolant temp
    if ($saw eq "010C")  {$port->write("41 0C 1A F8 >");}    # engine RPM
    if ($saw eq "03")    {$port->write("43 01 33 00 00 00 00 >");}
    

    
    usleep (10000);
}
