#!/bin/bash

TEMP_INDEX_FILE="/tmp/temp-index-file"

INDEX_FILE=$1
if [[ -z "$INDEX_FILE" ]];
then
    cat <<EOF
ERROR: First argument must be a path to the index file

Example:

    $0 INDEX_FILE_PATH
EOF
    exit 41
fi

if [[ ! -x $(which fd) && ! -x $(which fdfind) ]];
then
	echo "fd or fdfind is required"
	exit 42
fi

if [[ -x $(which fd) ]];
then
    EXECUTABLE=$(which fd)
else
    EXECUTABLE=$(which fdfind)
fi

if [ -z "$HOME" ];
then
	echo "Home directory must be defined"
	exit 44
fi

rm -f $TEMP_INDEX_FILE

# Exclude list
# - vendor: Golang vendor files
# - pkg: Golang compilation output of source
# - node_modules: Node.js dependencies
# - /System: Apple's Filesystem has a firmlink between /System/Volumes/Data/Users/... and /Users/...
#    - "firmlink" object is similar to symlink
#    - https://devstreaming-cdn.apple.com/videos/wwdc/2019/710aunvynji5emrl/710/710_whats_new_in_apple_file_systems.pdf
$EXECUTABLE '.*' --type f --type d --exclude vendor --exclude pkg --exclude node_modules --exclude /System > $TEMP_INDEX_FILE $HOME

INDEX_FILE_BAK=$INDEX_FILE.bak
rm -f $INDEX_FILE_BAK
if [ -f $INDEX_FILE ];
then
	cp $INDEX_FILE $INDEX_FILE_BAK
fi

mv $TEMP_INDEX_FILE $INDEX_FILE
