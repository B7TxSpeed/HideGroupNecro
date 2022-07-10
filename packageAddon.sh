#!/usr/bin/env bash

# Extract version
version=`grep -Po "(?<=Version: )[0-9]+\.[0-9]+\.[0-9]+" HideGroupNecro.txt`
# Package ZIP
mkdir -p HideGroupNecro
cp HideGroupNecro.txt HideGroupNecro/
cp *.lua HideGroupNecro/
# Create ZIP and clean directory
tar -acf HideGroupNecro-$version.zip HideGroupNecro
rm -rf HideGroupNecro
