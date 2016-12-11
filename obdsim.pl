#!/usr/bin/perl
$| = 1;

use strict;
use warnings;
use IO::Handle;
use Device::SerialPort;
use Time::HiRes qw( usleep );

my $com;
my $reply;
my $port = Device::SerialPort->new("/dev/pts/4");

# --------------- Windows ------------------
# use Win32::SerialPort;
# my $port = Win32::SerialPort->new("COM3");
# ------------------------------------------

$port->baudrate(9600); # Configure this to match your device
$port->databits(8);
$port->parity("none");
$port->stopbits(1);

print "Ready...\n";

while (1) {
    my ($count,$saw)=$port->read(255); # will read up to 255 chars
    chop $saw;
    
    if ($count != 0) {
        print "count=$count, data=$saw;--------- \n";

	if    ($saw eq "atz")   {$port->write("atz  ELM327 v1.5 >");}
	elsif ($saw eq "ate0")  {$port->write("ate0 OK >");}
	elsif ($saw eq "atl0")  {$port->write("OK >");}
	elsif ($saw eq "at\@1") {$port->write("OBDII to RS232 Interpreter >");}
	elsif ($saw eq "at\@2") {$port->write("? >");}
	
	elsif ($saw eq "03")    {$port->write("43 02 03 00 03 04 >");}  # Get diagnostic codes
	elsif ($saw eq "07")    {$port->write("47 02 03 00 03 04 >");}  # Get pending codes
	
	elsif ($saw eq "0100")  {$port->write("41 00 BE 1F B8 10 >");}  # Get supported PIDs
	elsif ($saw eq "0101")  {$port->write("41 01 82 07 E5 00 >");}  # Get num codes
	elsif ($saw eq "0103")  {$port->write("41 03 02 02 >");}        # Fuel system status
	elsif ($saw eq "0105")  {$port->write("41 05 7B >");}           # Coolant temp
	elsif ($saw eq "0106")  {$port->write("41 06 90 >");}           # STFT Bank 1
	elsif ($saw eq "0107")  {$port->write("41 07 90 >");}           # LTFT Bank 1
	elsif ($saw eq "0108")  {$port->write("41 08 90 >");}           # STFT Bank 2
	elsif ($saw eq "0109")  {$port->write("41 09 90 >");}           # LTFT Bank 2
	elsif ($saw eq "010B")  {$port->write("41 0B 1D >");}           #
	elsif ($saw eq "010C")  {$port->write("41 0C 1A F8 >");}        # engine RPM
	elsif ($saw eq "010E")  {$port->write("41 0E 9B >");}           # Timing advance
	elsif ($saw eq "010F")  {$port->write("41 0F 4A >");}           #
	else                    {$port->write("NO DATA >");}            #
    }
    usleep (10000);
}
