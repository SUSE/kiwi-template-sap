#!/bin/bash
# Copyright (c) 2016 SUSE Linux GmbH, Nuernberg, Germany.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Authored: Howard Guo <hguo@suse.com>
# The script is inspired by SLES 12 SP1 JEOS.
# 
echo "Configuring SLES4SAP image..."
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

mkdir /var/lib/misc/reconfig_system
rm /etc/machine-id
rm /etc/localtime
rm /var/lib/zypp/AnonymousUniqueId
rm /var/lib/systemd/random-seed
> /var/log/zypper.log

suseConfig
suseSetupProduct
suseImportBuildKey

baseUpdateSysConfig /etc/sysconfig/SuSEfirewall2 FW_CONFIGURATIONS_EXT "sshd xrdp"
baseUpdateSysConfig /etc/sysconfig/console CONSOLE_FONT "lat9w-16.psfu"
baseUpdateSysConfig /etc/sysconfig/network/dhcp DHCLIENT_SET_HOSTNAME yes
baseUpdateSysConfig /etc/sysconfig/language RC_LANG "en_US.UTF-8"
baseUpdateSysConfig /etc/sysconfig/language ROOT_USES_LANG "yes"
baseUpdateSysConfig /etc/sysconfig/language INSTALLED_LANGUAGES "en_US"
echo 'server 0.pool.ntp.org iburst' >> /etc/ntp.conf
echo 'server 1.pool.ntp.org iburst' >> /etc/ntp.conf
echo 'server 2.pool.ntp.org iburst' >> /etc/ntp.conf

/sbin/ldconfig
/usr/sbin/update-ca-certificates
/usr/bin/chkstat -n --set --system --fscaps

systemctl mask systemd-firstboot.service
systemctl enable SuSEfirewall2.service SuSEfirewall2_init.service
systemctl enable sshd.service ntpd.service xrdp.service
systemctl set-default multi-user.target

baseCleanMount

exit 0
