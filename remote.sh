#! /bin/bash
#
# This will take a server hostname, compare it against a file, translate it to an IP
# and launch rdesktop with a specific set of opitions.  The file can be created using
# the script MRConversion.  You can use your own file as well, the format is 
# two columns: hostname  IP Address.  As of now it will also do simple pattern matching
# ex. user enters db and servers are in the form xx-db-xx and it will open all db servers 
# in seperate windows
#
#matt jones
#updated 12/02/11
#copyright GPL v2


declare Input="$1" # the server hostname or pattern you wish to connect to
declare ServerList="/home/matty/bin/scripts/remote/ServerList.txt" #the file created by MRConversion used for the translation
declare ServerName="" #the server name, used to ID the window
declare LocalSharedDisk="$HOME" #set the directory to share with the remote host
declare SharedDiskName="$USER" #the name of the shared disk on the remote system
declare Resolution="1024x768" #the desired resolution, replace -g $Resolution with -f for full screen
declare UserName="" #the desired username

#---this will give me the matching servers to the criteria---#
set $(grep -c -i $Input $ServerList)
declare ServerCount=$1

#this will go through the Server List file and match the hostname(s) to IP and run rdektop with the above config
for (( i = 1; i <= $ServerCount; i++ ))

	do
		set $(grep -m $i $Input $ServerList | awk -v i="$i" 'NR == i {print $1}') #the host name
		declare ServerName=$1
		 
		set $(grep -m $i $Input $ServerList |  awk -v i="$i" 'NR == i {print $2}')
		declare RemoteServer=$1 #set the IP address from the above statement
		
		rdesktop -g $Resolution -r disk:$SharedDiskName=$LocalSharedDisk -u "$UserName" -0 -T $ServerName -N $RemoteServer & 
		
done
