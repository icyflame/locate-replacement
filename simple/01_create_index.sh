#!/bin/bash

TEMP_INDEX_FILE="/tmp/temp-index-file"

INDEX_FILE=$1
if [[ -z "$INDEX_FILE" ]];
then
    cat <<EOF
ERROR: First argument must be a path to the index file

Example:

    $0 INDEX_FILE_PATH [ROOT_DIRECTORY_FOR_SEARCH]
EOF
    exit 41
fi

ROOT_FOR_SEARCH=${2:-$HOME}
if [ -z "$ROOT_FOR_SEARCH" ];
then
    cat <<EOF
ERROR: ROOT_FOR_SEARCH directory must be defined

Example:

    $0 INDEX_FILE_PATH [ROOT_DIRECTORY_FOR_SEARCH]
EOF
	exit 42
fi

if [[ ! -x $(which fd) && ! -x $(which fdfind) ]];
then
	echo "fd or fdfind is required"
	exit 43
fi

if [[ -x $(which fd) ]];
then
    EXECUTABLE=$(which fd)
else
    EXECUTABLE=$(which fdfind)
fi

rm -f $TEMP_INDEX_FILE

# Exclude list
# - vendor: Golang vendor files
# - pkg: Golang compilation output of source
# - node_modules: Node.js dependencies
# - /System: Apple's Filesystem has a firmlink between /System/Volumes/Data/Users/... and /Users/...
#    - "firmlink" object is similar to symlink
#    - https://devstreaming-cdn.apple.com/videos/wwdc/2019/710aunvynji5emrl/710/710_whats_new_in_apple_file_systems.pdf
$EXECUTABLE '.*' --type f --type d --exclude vendor --exclude pkg --exclude node_modules --exclude /System > $TEMP_INDEX_FILE $ROOT_FOR_SEARCH

mv $TEMP_INDEX_FILE $INDEX_FILE
