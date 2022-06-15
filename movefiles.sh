#!/bin/bash

while getopts "r:s:d:" flag 
    do
        case "${flag}" in  
            r) filename=${OPTARG};;
            s) src_dir=${OPTARG};;
            d) dest_dir=${OPTARG};;
        esac
    done

exec 3<$filename
while read line <&3
    do
        if [ "$line" != "" ]; then
            src_file=$src_dir/$line
            dest_file=$dest_dir/$line
            echo "Copying $src_file to $dest_file"
            cp $src_file "$dest_dir"
        fi 
    done
