#!/usr/bin/env bash

echo "-- Check one time builded packages and them to pkglist"

sudo pacman -Sy

pacman -Sl needrelax

pacman -Sl needrelax |awk '{print $2}' > actualpkglist

sort pkglist actualpkglist | uniq > totalpkglist

echo "-- Check packages dependencies --"

while read line;
do aur depends -n $line >> pkg-depend-list;
done < totalpkglist

echo "-- Total pkg num --"

cat pkg-depend-list |wc -l

echo "-- Total pkg list --"

cat pkg-depend-list
