#! /bin/bash
#
# This file takes the output xml file from mremote and strips out the hostname and IP
# and creates a two-column list in a text file.  This file is then read by remote.sh 
# which matches the hostname to the IP and launches rdesktop with a specific set of opitions
#
# Matt Jones caffeinatedengineering@gmail.com
#updated 11/28/11
#copyright GPL v2

declare temp="temp.txt" #temp file, nothing special
declare ServerList="ServerList.txt" #the name of the file to be created

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
		if grep $Date $ServerList &> /dev/null #redirect all output to the trash
		then echo "The server list is already up to date"
			 rm $temp

		else sed 's/\(.*\)/\L\1/' $temp > $ServerList #convert everything to lowercase for ease of use
			 rm $temp
		fi
elif [ "$Ans" = "no" ]
	then echo #add another function to run here
else update_list #restart the process if anything else is given
fi
	
}

#test to see if the file is already present, if so then check the timestamp
if [ ! -f $ServerList ]
then
create_list #create a new file

else 
update_list #create a new file/check the current file

fi
