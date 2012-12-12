#!/bin/sh
#/*
#   ddldown - download file directly from ddlstorage
#   Copyright (C) 2012  REmaxer <remaxer@hotmail.it>
#   
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#check if directories exist
if [ ! -d "Pages" ];then 
	mkdir Pages
fi
if [ ! -d "Files" ];then
	mkdir Files
fi

URL=$1 #url typed
echo "Downloading from $URL"
wget --directory-prefix="Pages"  --load-cookies cookies.txt $URL #downloading first page
#define first file name through a regexp
FIRST_FILE=$(echo $URL | grep -Po '(?<=http://www.ddlstorage.com/).+'| cut -c 14-)
echo "First file name is $FIRST_FILE"
#setting post data
OP=download2
RAND=$(grep -Po '(?<=rand" value=")\w+' Pages/$FIRST_FILE) #using regexp
ID=$(echo $URL | grep -Po '(?<=http://www.ddlstorage.com/)\w+') #using regexp
METHOD_PREMIUM=1
DOWN_DIRECT=1
#debugging
echo -e "DEBUGGING:\n OP=$OP \n RAND=$RAND \n ID=$ID \n METHOD_PREMIUM=$METHOD_PREMIUM \n DOWN_DIRECT=$DOWN_DIRECT \n"
#defining post data string
POST_DATA=$(echo "op=$OP&id=$ID&rand=$RAND&method_premium=$METHOD_PREMIUM&down_direct=$DOWN_DIRECT")
echo "POST DATA will be '$POST_DATA'"
#downloading second file
wget --directory-prefix="Pages" --load-cookies cookies.txt --post-data=$POST_DATA $URL
SECOND_FILE=$FIRST_FILE.1
echo "Second file name is $SECOND_FILE"
# !!!! Downloading final file !!!!
FINAL_FILE_URL=$(grep -Po '(?<=4px;"><a href=")http://[^"]+' Pages/$SECOND_FILE )
echo "Final file URL is $FINAL_FILE_URL"
wget --directory-prefix="Files" --load-cookies cookies.txt $FINAL_FILE_URL



