#! /bin/bash
#
# This will take a server hostname, compare it against a file, translate it to an IP
# and launch rdesktop with a specific set of opitions.  The file can be created using
# the script MRConversion.  You can use your own file as well, the format is 
# two columns: hostname  IP Address.
#
#matt jones
#urlugal@gmail.com 
#updated 11/28/11
#copyright GPL v2


declare Input="$1" # the server hostname you wish to connect to
declare ServerList="/home/matty/bin/scripts/remote/ServerList.txt" #the file created by MRConversion used for the translation

declare LocalSharedDisk="$HOME" #set the directory to share with the remote host
declare SharedDiskName="$USER" #the name of the shared disk on the remote system
declare Resolution="1024x768" #the desired resolution, replace -g $Resolution with -f for full screen
declare UserName="matthew jones" #the desired username

set $(grep $Input $ServerList | awk '{print $2}') #find the server name in the file and get the IP address
declare RemoteServer=$1 #set the IP address from the above statement

#run rdesktop
rdesktop -g $Resolution -r disk:$SharedDiskName=$LocalSharedDisk -u "$UserName" -0 -T $Input -N $RemoteServer & 
