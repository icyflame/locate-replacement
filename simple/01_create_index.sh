#!/bin/bash

source vars

if [ ! -x $(which fd) ];
then
	echo "fd is required"
	exit 42
fi

if [ -z "$HOME" ];
then
	echo "Home directory must be defined"
	exit 44
fi

rm -f $TEMP_INDEX_FILE
fd '.*' --exclude vendor --exclude node_modules > $TEMP_INDEX_FILE /

INDEX_FILE_BAK=$INDEX_FILE.bak
rm -f $INDEX_FILE_BAK
if [ -f $INDEX_FILE ];
then
	cp $INDEX_FILE $INDEX_FILE_BAK
fi

mv $TEMP_INDEX_FILE $INDEX_FILE
