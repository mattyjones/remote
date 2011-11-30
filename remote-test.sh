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

#----------Variables----------#
declare temp="temp.txt" #temp file, nothing special
declare OutputFile="ServerList.txt" #the name of the file to be created
#declare Arg="$1" #commanline argument
declare ServerConnect= #"$OPTARG" #the server to connect to
declare ServerList="/home/matty/bin/scripts/remote/ServerList.txt" #the file created by MRConversion used for the translation
declare LocalSharedDisk="$HOME" #set the directory to share with the remote host
declare SharedDiskName="$USER" #the name of the shared disk on the remote system
declare Resolution="1024x768" #the desired resolution, replace -g $Resolution with -f for full screen
declare UserName="" #the desired username
set $(grep $ServerConnect $ServerList | awk '{print $2}') #find the server name in the file and get the IP address
declare RemoteServer=$1 #set the IP address from the above statement

#----------end variables----------#

#----------functions----------#
create_list(){ #this is if the file dosen't exist at all
echo "Please enter the full path of the mremote XML file"
read InputFile

# use " as a field seperator and print the second and eighteenth column the send it
# to sed to chop off the extra lines and save it to a temp file
awk < $InputFile -F\" '{print $2, $18}' | sed -n '4~1p' > $temp

stat -c %y $InputFile >> $temp #get the creation date of the input file and append it to the temp file

sed 's/\(.*\)/\L\1/' $temp > $ServerList #convert everything to lowercase for ease of use
rm $temp #delete the temp file

}

update_list(){ #this runs if a file is detected
echo "Do you want to update the server list? (yes/no)"
read Ans
if [ "$Ans" = "yes" ]
	then echo "Please enter the full path of the mremote XML file"
 		 read InputFile
		 # use " as a field seperator and print the second and eighteenth column the send it
		 # to sed to chop off the extra lines and save it to a temp file
		 awk < $InputFile -F\" '{print $2, $18}' | sed -n '4~1p' > $temp
		 stat -c %y $InputFile >> $temp #get the creation date of the input file and append it to the temp file
		 set $(sed -n '$p' $temp) #get the last line of the temp file and set it to Date
		 declare Date="$1"

		# this will compare the date of the input file in the temp file to the date of the input file in the
		# current server list.  If the are the same then the temp file is deleted, the they are different then
		# the temp file is set to all lowercase for ease of use and set to the ServerList variable name. 
		if grep $Date $OutputFile &> /dev/null #redirect all output to the trash
		then echo "The server list is already up to date"
			 rm $temp

		else sed 's/\(.*\)/\L\1/' $temp > $OutputFile #convert everything to lowercase for ease of use
			 rm $temp
		fi
elif [ "$Ans" = "no" ]
	then echo #add another function to run here
else update_list #restart the process if anything else is given
fi
	
}

check_list(){ #test to see if the file is already present, if so then check the timestamp
if [ ! -f $OutputFile ]
then
create_list #create a new file

else 
update_list #create a new file/check the current file

fi
}

connect_server(){ #connect to the server
rdesktop -g $Resolution -r disk:$SharedDiskName=$LocalSharedDisk -u "$UserName" -0 -T $ServerConnect -N $RemoteServer & 
}

help(){ #help 
echo	
}

version(){ #version
echo
}

#----------end functions----------#

while getopts "c:uh" Option
do
  case $Option in
	c)
        echo "c was pressed"
        ServerConnect="$OPTARG"
 rdesktop -g $Resolution -r disk:$SharedDiskName=$LocalSharedDisk -u "$UserName" -0 -T $ServerConnect -N $RemoteServer & 
        ;;
    u)
        check_list
        ;;
	h)
        help
        ;;
    v)
        version
        ;;
   esac    
done
#shift $(($OPTIND - 1))