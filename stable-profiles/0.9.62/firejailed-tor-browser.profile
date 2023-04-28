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
# Backported profile for firejail 0.9.62
#

# Report any issues at
#  <https://github.com/samsapti/firejailed-mullvad-browser/issues/new>

# Persistent local customizations
include firejailed-mullvad-browser.local
# Persistent global definitions
include globals.local

# Note: PluggableTransports didn't work with this profile

ignore noexec ${HOME}

noblacklist ${HOME}/.firejailed-mullvad-browser

blacklist /opt
blacklist /srv
blacklist /sys
blacklist /tmp/.X11-unix
blacklist /usr/games
blacklist /usr/libexec
blacklist /usr/local
blacklist /usr/src
blacklist /var

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc

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
seccomp !chroot,@memlock,@setuid,@timer,io_pgetevents
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

env MOZ_ENABLE_WAYLAND=1
name firejailed-mullvad-browser
read-only /tmp
read-only ${HOME}
read-write ${HOME}/Browser
read-write ${HOME}/Data
read-write ${HOME}/UpdateInfo
# rmenv DISPLAY -- does not work ATOW because mbb requires $DISPLAY to be set and not empty.
env DISPLAY=wayland_is_better
rmenv XAUTHORITY
