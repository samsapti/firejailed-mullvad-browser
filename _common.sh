# shellcheck shell=bash

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

FMB_HOME="$HOME/.firejailed-mullvad-browser"
FMB_DESKTOP="firejailed-mullvad-browser.desktop"
FMB_DESKTOP_DEST="${XDG_DATA_HOME:-"$HOME"/.local/share}/applications/$FMB_DESKTOP"
FMB_LOCAL="firejailed-mullvad-browser.local"
FMB_PROFILE="firejailed-mullvad-browser.profile"
FMB_X11_INC="firejailed-mullvad-browser-x11.inc"
SUPPORTED_FIREJAIL_VERSIONS=("git" "0.9.70" "0.9.66" "0.9.64.4" "0.9.62" "0.9.58")

CFG_FIREJAIL_VERSION="git"
CFG_SRC="."
CFG_MBB_PATH="PATH_TO_MULLVAD_BROWSER_ARCHIVE"
CFG_X11=no
if [[ -z "$WAYLAND_DISPLAY" ]]; then
  echo "[ Info ] \$WAYLAND_DISPLAY is unset (or empty). Allow X11."
  CFG_X11=yes
fi


usage()
{
  cat <<-EOM
Usage:
    $0 [OPTIONS] [PATH_TO_MULLVAD_BROWSER_ARCHIVE]

OPTIONS:
  --help,-h,-?        Show this help and exit.
  --firejail=VERSION  Specify firejail version (default: git)
                       supported versions: ${SUPPORTED_FIREJAIL_VERSIONS[@]}
  --x11               Allow X11 and do not force Wayland
EOM
  exit 0
}

parse_arguments()
{
  for arg in "$@"; do
    case $arg in
      --help|-h|-\?)
        usage
      ;;
      --firejail=*)
        CFG_FIREJAIL_VERSION="${arg#*=}"
      ;;
      --x11)
        CFG_X11=yes
      ;;
      --*|-?)
        echo "[ Warning ] Unknown commandline argument: $arg"
      ;;
      *)
        CFG_MBB_PATH="$arg"
        break
      ;;
    esac
  done

  check_firejail_version
}

create_backup()
{
  # Move $1 to $1.bak-NOW if it exist
  if [[ -e "$1" ]]; then
    mv "$1" "$1.bak-$(date --iso-8601=seconds)"
    echo "[ Ok ] Created backup of '$1'."
  fi
}

check_firejail_version()
{
  if [[ "$CFG_FIREJAIL_VERSION" == "git" ]]; then
    return 0
  fi

  supported=false
  for version in "${SUPPORTED_FIREJAIL_VERSIONS[@]}"; do
    if [[ "$CFG_FIREJAIL_VERSION" == "$version" ]]; then
      supported=true
      CFG_SRC="./stable-profiles/$CFG_FIREJAIL_VERSION"
      break
    fi
  done

  if [[ "$supported" == "false" ]]; then
    echo "[ Error ] Unsupported firejail version '$CFG_FIREJAIL_VERSION'."
    exit 1
  fi
}

fix_disable-programs()
{
  if [[ "$FIREJAIL_VERSION" == "0.9.58" ]]; then
    echo "[ Warning ] Fixing disable-programs is only supported for firejail 0.9.60 and newer."
    echo "[ Info ] To fix disable-programs manually execute the following as root if you know what it does:"
    echo "[ Info ]     sh -c 'echo \${HOME}/.firejailed-mullvad-browser' >> /etc/firejail/disable-programs.local"
    return 0
  fi

  DISABLE_PROGRAMS_LOCAL="${HOME}/.config/firejail/disable-programs.local"
  BLACKLIST_FMB="blacklist \${HOME}/.firejailed-mullvad-browser"

  # grep prints errors about non-existing files even with --quiet
  touch "$DISABLE_PROGRAMS_LOCAL"

  # Add $BLACKLIST_FMB to disable-programs.inc unless it's present.
  if ! grep --quiet "$BLACKLIST_FMB" "$DISABLE_PROGRAMS_LOCAL"; then
    echo "$BLACKLIST_FMB" >> "$DISABLE_PROGRAMS_LOCAL"
    echo "[ Ok ] Fixed disbale-programs.inc."
  fi
}

allow_x11_if_wanted()
{
  if [[ "$CFG_X11" != "yes" ]]; then
    return
  fi

  touch "$HOME/.config/firejail/$FMB_LOCAL"

  INCLUDE_FMB_X11_INC="include firejailed-mullvad-browser-x11.inc"

  if ! grep --quiet "^$INCLUDE_FMB_X11_INC" "$HOME/.config/firejail/$FMB_LOCAL"; then
    echo "$INCLUDE_FMB_X11_INC" >> "$HOME/.config/firejail/$FMB_LOCAL"
    echo "[ Ok ] Allowed X11."
  fi
}


install_fj()
{
  create_backup "$HOME/.config/firejail/$FMB_PROFILE"
  install -Dm0644 "$CFG_SRC/$FMB_PROFILE" "$HOME/.config/firejail/$FMB_PROFILE"
  echo "[ Ok ] Installed $FMB_PROFILE."

  if [[ -e "$CFG_SRC/$FMB_X11_INC" ]]; then
    create_backup "$HOME/.config/firejail/$FMB_X11_INC"
    install -Dm0644 "$CFG_SRC/$FMB_X11_INC" "$HOME/.config/firejail/$FMB_X11_INC"
    echo "[ Ok ] Installed $FMB_X11_INC."
  fi

  fix_disable-programs
  allow_x11_if_wanted
}

install_de()
{
  create_backup "$FMB_DESKTOP_DEST"
  mkdir -v -p "$(dirname "$FMB_DESKTOP_DEST")"
  sed "s,HOME,$HOME,g" < "$CFG_SRC/$FMB_DESKTOP.in" > "$FMB_DESKTOP_DEST"
  echo "[ Ok ] Installed $FMB_DESKTOP."
}

# vim: ft=bash sw=4 ts=4 sts=4 et ai
