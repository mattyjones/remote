Copyright 2011-2012 Matt Jones
 
    This is free software: you can redistribute it and/or modify
	it under the terms of the General Public License either version 2 of the License, or
    (at your option) any later version.
	
For the latest developments on the project check out <https://github.com/urlugal/remote>.

This is a simple commandline substitute for MRemote.  This will take a server hostname, compare it against a file, translate it to an IP and launch rdesktop with a specific set of opitions.  The file can be created using
the script MRConversion.  You can use your own file as well, the format is two columns: hostname  IP Address.  As of now it will also do simple pattern matching ex. user enters db and servers that are in the form xx-db-xx, will be opened in seperate windows

---List of Files---

MRConversion.sh
--This file takes the output xml file from mremote and strips out the hostname and IP
and creates a two-column list in a text file. 

remote.sh
-- This will take a server hostname, compare it against a file, translate it to an IP
and launch rdesktop with a specific set of opitions.  It will also do simple pattern matching
ex. user enters db and servers are in the form xx-db-xx and it will open all db servers 
in seperate windows

remote-testing.sh
--for testing, this may or may not working depending on the day

COPYING.txt
--copyright infomation