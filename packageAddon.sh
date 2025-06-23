#!/usr/bin/env bash

# Extract version
version=`grep -Po "(?<=Version: )[0-9]+\.[0-9]+\.[0-9]+" HideGroupNecro.addon`
# Package ZIP
mkdir -p HideGroupNecro
cp HideGroupNecro.addon HideGroupNecro/
cp *.lua HideGroupNecro/
cp *.xml HideGroupNecro/
mkdir -p HideGroupNecro/locales
cp locales/*.lua HideGroupNecro/locales/
# Create ZIP and clean directory
"C:\Program Files\7-Zip\7z" a -tzip HideGroupNecro-$version.zip HideGroupNecro
rm -rf HideGroupNecro
