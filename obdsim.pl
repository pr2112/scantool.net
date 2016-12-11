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

	if    ($saw eq "atz")   {$reply = "atz  ELM327 v1.5 >";}
	elsif ($saw eq "ate0")  {$reply = "ate0 OK >";}
	elsif ($saw eq "atl0")  {$reply = "OK >";}
	elsif ($saw eq "at\@1") {$reply = "OBDII to RS232 Interpreter >";}
	elsif ($saw eq "at\@2") {$reply = "? >";}
	
	elsif ($saw eq "03")    {$reply = "43 02 03 00 03 04 >";}  # Get diagnostic codes
	elsif ($saw eq "07")    {$reply = "47 02 03 00 03 04 >";}  # Get pending codes
	
	elsif ($saw eq "0100")  {$reply = "41 00 BE 1F B8 10 >";}  # Get supported PIDs
	elsif ($saw eq "0101")  {$reply = "41 01 82 07 E5 00 >";}  # Get num codes
	elsif ($saw eq "0103")  {$reply = "41 03 02 02 >";}        # Fuel system status
	elsif ($saw eq "0105")  {$reply = "41 05 7B >";}           # Coolant temp
	elsif ($saw eq "0106")  {$reply = "41 06 90 >";}           # STFT Bank 1
	elsif ($saw eq "0107")  {$reply = "41 07 90 >";}           # LTFT Bank 1
	elsif ($saw eq "0108")  {$reply = "41 08 90 >";}           # STFT Bank 2
	elsif ($saw eq "0109")  {$reply = "41 09 90 >";}           # LTFT Bank 2
	elsif ($saw eq "010B")  {$reply = "41 0B 1D >";}           #
	elsif ($saw eq "010C")  {$reply = "41 0C 1A F8 >";}        # engine RPM
	elsif ($saw eq "010E")  {$reply = "41 0E 9B >";}           # Timing advance
	elsif ($saw eq "010F")  {$reply = "41 0F 4A >";}           #
	else                    {$reply = "NO DATA >";}            #
	$port->write ($reply);
    }
    usleep (10000);
}
