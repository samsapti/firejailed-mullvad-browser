# vim: ft=firejail
# Copyright © 2019-2023 rusty-snake and contributors, 2023 Sam A. and contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

############################################################
#                                                          #
#            HOW TO: Firejailed Mullvad Browser            #
#  https://github.com/samsapti/firejailed-mullvad-browser  #
#                                                          #
############################################################

#
# Backported profile for firejail 0.9.58
#

# Report any issues at
#  <https://github.com/samsapti/firejailed-mullvad-browser/issues/new>

# Persistent local customizations
include firejailed-mullvad-browser.local
# Persistent global definitions
include globals.local

# Note: PluggableTransports didn't work with this profile

noblacklist ${HOME}/.firejailed-mullvad-browser

blacklist /opt
blacklist /run/dbus/system_bus_socket
blacklist /srv
blacklist /sys
blacklist /usr/games
blacklist /usr/local
blacklist /usr/src
blacklist /var

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.firejailed-mullvad-browser
whitelist /usr/share/alsa
whitelist /usr/share/applications
whitelist /usr/share/ca-certificates
whitelist /usr/share/crypto-policies
whitelist /usr/share/cursors
whitelist /usr/share/dconf
whitelist /usr/share/distro-info
whitelist /usr/share/drirc.d
whitelist /usr/share/enchant
whitelist /usr/share/enchant-2
whitelist /usr/share/fontconfig
whitelist /usr/share/fonts
whitelist /usr/share/gir-1.0
whitelist /usr/share/gjs-1.0
whitelist /usr/share/glib-2.0
whitelist /usr/share/glvnd
whitelist /usr/share/gtk-2.0
whitelist /usr/share/gtk-3.0
whitelist /usr/share/gtksourceview-3.0
whitelist /usr/share/gtksourceview-4
whitelist /usr/share/hunspell
whitelist /usr/share/hwdata
whitelist /usr/share/icons
whitelist /usr/share/knotifications5
whitelist /usr/share/kservices5
whitelist /usr/share/Kvantum
whitelist /usr/share/kxmlgui5
whitelist /usr/share/libdrm
whitelist /usr/share/libthai
whitelist /usr/share/locale
whitelist /usr/share/mime
whitelist /usr/share/misc
whitelist /usr/share/Modules
whitelist /usr/share/myspell
whitelist /usr/share/p11-kit
whitelist /usr/share/pixmaps
whitelist /usr/share/pki
whitelist /usr/share/plasma
whitelist /usr/share/qt
whitelist /usr/share/qt4
whitelist /usr/share/qt5
whitelist /usr/share/sounds
whitelist /usr/share/tcl8.6
whitelist /usr/share/terminfo
whitelist /usr/share/themes
whitelist /usr/share/thumbnail.so
whitelist /usr/share/X11
whitelist /usr/share/xml
whitelist /usr/share/zoneinfo

apparmor
caps.drop all
#hostname host
# causes some graphics issues
ipc-namespace
# Breaks sound; enable it if you don't need sound
#machine-id
netfilter
# Disable hardware acceleration
#no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
# Disable sound, enable if you don't need
#nosound
notv
nou2f
novideo
protocol unix,inet,inet6
# @default-nodebuggers without chroot
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
seccomp.block-secondary
shell none
# Cause some issues
#tracelog

disable-mnt
private ${HOME}/.firejailed-mullvad-browser
# These are the minimum required programms to start the MBB,
# you maybe need to add one or more programs from the commented private-bin line below.
# To get full support of the scripts start-mullvad-browser, execdesktop and mullvadbrowser
# (this is a wrapper script, the firefox browser executable is mullvadbrowser.real) in the MBB,
# add the commented private-bin line to firejailed-mullvad-browser.local
private-bin bash,dirname,env,expr,file,getconf,grep,rm,sh
private-cache
private-dev
# This is a minimal private-etc, if there are breakages due it you need to add more files.
# To get ideas what maybe needs to be added look at the templates:
# https://github.com/netblue30/firejail/blob/28142bbc49ecc3246033cbc810d7f04027c87f4d/etc/templates/profile.template#L151-L162
private-etc machine-id
# On Arch you maybe need to uncomment the following (or add to your firejailed-mullvad-browser.local).
# See https://github.com/netblue30/firejail/issues/3158
#private-etc ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload
private-tmp

name firejailed-mullvad-browser
noexec ${RUNUSER}
noexec /dev/shm
noexec /tmp
