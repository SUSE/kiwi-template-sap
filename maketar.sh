#!/bin/sh
[ -z "$1" ] && echo "$0 <version_number>" && exit 1
tar zcvf kiwi-template-sap-$1.tar.gz SLES4SAP
