#!/usr/bin/env bash

# Extract version
version=`grep -Po "(?<=Version: )[0-9]+\.[0-9]+\.[0-9]+" HideGroupNecro.txt`
# Package ZIP
mkdir -p HideGroupNecro
cp HideGroupNecro.txt HideGroupNecro/
cp *.lua HideGroupNecro/
cp *.xml HideGroupNecro/
# Create ZIP and clean directory
"C:\Program Files\7-Zip\7z" a -tzip HideGroupNecro-$version.zip HideGroupNecro
rm -rf HideGroupNecro
