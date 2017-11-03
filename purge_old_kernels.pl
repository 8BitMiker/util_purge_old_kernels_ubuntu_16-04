#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
$|++;

my $db = [];
my $path = '/boot/';

# -------------------------------------------
# Notes
# -------------------------------------------

# Detailed explaination to fix @
# https://askubuntu.com/questions/345588/what-is-the-safest-way-to-clean-up-boot-partition

# Command to list all kernels
# dpkg --list 'linux-image*'

# Command to find deletable kernals
# sudo dpkg --list 'linux-image*'|awk '{ if ($1=="ii") print $2}'|grep -v `uname -r`

# Command for current kernel
# uname -r

# For non corrupt state
# sudo apt-get autoremove --purge
# or ...
# The purge-old-kernels tool can be installed via sudo apt install byobu. Here is the description from its man-page:
# sudo purge-old-kernels

# For corrupt state use
# sudo apt-get -f install


# -------------------------------------------
# As a one liner
# -------------------------------------------

# cd /boot && ls | perl -nle 'BEGIN{ $r = qr~(\d[\w\.-]+)~; ($k) = `uname -r` =~ m~$r~ } print if $_ !~  m~$k~ and (m~$r~)' | xargs -n 1 sudo rm

# -------------------------------------------
# Gather current kernel info
# -------------------------------------------
chomp( my $kernel = `uname -r`);

print "Current kernel: ${kernel} ... (Press enter to begin)\n"; <>;

# -------------------------------------------
# Sorcery code to create kernal delete list
# -------------------------------------------
my $delete = join '|', grep 
{ 
	 
	$_->[0] =~ m~^ii$~ && ($_->[1] !~ m~${kernel}~i)
		? ($_) = $_->[1] =~ m~(\d+[\.\d-]+(?i)[A-Z]+)~
		: (); 

} @{[map { [ split " ", $_ ] } `dpkg --list 'linux-image*'`]};

# -------------------------------------------
# Delete Unnessesry Files
# -------------------------------------------
while ( glob(qq~${path}*~) )
{
	
	chomp;
	system qq~sudo rm -i ${_}~ 
		if $_ =~ m~$delete~;
	
}

__END__

# EXAMPLE DATA FROM dpkg --list 'linux-image*

Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                               Version                Architecture           Description
+++-==================================-======================-======================-=========================================================================
un  linux-image                        <none>                 <none>                 (no description available)
rc  linux-image-4.4.0-21-generic       4.4.0-21.37            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
rc  linux-image-4.4.0-62-generic       4.4.0-62.83            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
rc  linux-image-4.4.0-63-generic       4.4.0-63.84            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-64-generic       4.4.0-64.85            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-66-generic       4.4.0-66.87            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-70-generic       4.4.0-70.91            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-71-generic       4.4.0-71.92            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-72-generic       4.4.0-72.93            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-75-generic       4.4.0-75.96            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-78-generic       4.4.0-78.99            amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-79-generic       4.4.0-79.100           amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-4.4.0-81-generic       4.4.0-81.104           amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
iF  linux-image-4.4.0-83-generic       4.4.0-83.106           amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
iF  linux-image-4.4.0-87-generic       4.4.0-87.110           amd64                  Linux kernel image for version 4.4.0 on 64 bit x86 SMP
in  linux-image-4.4.0-89-generic       <none>                 amd64                  (no description available)
rc  linux-image-extra-4.4.0-21-generic 4.4.0-21.37            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
rc  linux-image-extra-4.4.0-62-generic 4.4.0-62.83            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
rc  linux-image-extra-4.4.0-63-generic 4.4.0-63.84            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-extra-4.4.0-64-generic 4.4.0-64.85            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-extra-4.4.0-66-generic 4.4.0-66.87            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-extra-4.4.0-70-generic 4.4.0-70.91            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-extra-4.4.0-71-generic 4.4.0-71.92            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-extra-4.4.0-72-generic 4.4.0-72.93            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-extra-4.4.0-75-generic 4.4.0-75.96            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-extra-4.4.0-78-generic 4.4.0-78.99            amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
ii  linux-image-extra-4.4.0-79-generic 4.4.0-79.100           amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
iF  linux-image-extra-4.4.0-81-generic 4.4.0-81.104           amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
iU  linux-image-extra-4.4.0-83-generic 4.4.0-83.106           amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
iU  linux-image-extra-4.4.0-87-generic 4.4.0-87.110           amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
iU  linux-image-extra-4.4.0-89-generic 4.4.0-89.112           amd64                  Linux kernel extra modules for version 4.4.0 on 64 bit x86 SMP
iU  linux-image-generic                4.4.0.89.95            amd64                  Generic Linux kernel image


