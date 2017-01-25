#!/bin/sh
rm -rf build fsroot*
find SLES4SAP/root/ -type d -exec chmod 755 {} \;
find SLES4SAP/root/ -type f -exec chmod 644 {} \;
kiwi -p SLES4SAP --root fsroot
mkdir -p build
kiwi --create fsroot --type vmx -d build
rm /home/howard/testvm/*.raw
cp build/*.raw /home/howard/testvm/
chmod 755 /home/howard /home/howard/testvm /home/howard/testvm/*

