#!/usr/bin/env bash

echo "-- Check packages dependencies --"

while read line;
do aur depends -n $line >> pkg-depend-list;
done < pkglist

echo "-- Total pkg list --"

cat pkg-depend-list 
