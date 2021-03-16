#!/bin/bash

googledir="YOUR GOOGLE KEY"
notifyemail="somename@somedomain.com"
backdir="/this/directory/here"

cd "$backdir"
echo "Searching for database files...."

filenum="ls -1 *.sql.gz 2>/dev/null | wc -l"

if [ "$filenum" != 0 ]; then
echo "Files found"
    
	for i in $(ls *.sql.gz); do
    	echo "Preparing $i for upload....."
        newname=$(date +%F-%H:%M_$i)
        mv $i $newname
    	gdrive upload --parent $googledir $newname
    	echo "$newname Successfully uploaded to google drive...."
    	echo "Moving $newname to archive directory....."
    	mv $newname "/backup/storage/lives/here/$newname"
    	echo "$newname has been successfully moved..."
	done
    
    mail -s "Database backup $filenum has been moved." $notifyemail <<< "$filenum database files have been moved to google drive for archiving."
    echo "Notificaiton: Upload has completed, Status email has been sent"

else
	filenum=0
	mail -s "Database backup $filenum has been moved." $notifyemail <<< "$filenum database files have been moved to google drive for archiving."
    echo "Notificaiton: Nothing to upload, Status email has been sent"
fi
