#!/usr/bin/env bash

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

set -eo pipefail
umask 077

# cd into the project directory
cd -P -- "$(readlink -e "$(dirname "$0")")"

source _common.sh

install_tb()
{
  if [[ ! -e "$CFG_MBB_PATH" ]]; then
    echo "[ Error ] Could not find '$CFG_MBB_PATH'"
    exit 1
  fi

  create_backup "$FMB_HOME"
  mkdir -p "$FMB_HOME"

  echo "[ Info ] Extracting the mullvad-browser ..."
  tar -C "$FMB_HOME" --strip 1 -xJf "$CFG_MBB_PATH"
  echo "[ Info ] Creating needed directories ..."
  mkdir "$FMB_HOME/Data" "$FMB_HOME/UpdateInfo"
  echo "[ Ok ] mullvad-browser installed."
}

main()
{
  parse_arguments "$@"
  install_de
  install_fj
  install_tb

  echo "[ Ok ] Done! The installation was successful, you can now launch Mullvad Browser by running:"
  echo "[ Ok ]   firejail --profile=firejailed-mullvad-browser \"\$HOME/Browser/start-mullvad-browser\" --name=\"Mullvad Browser\""
}

[ "${BASH_SOURCE[0]}" == "$0" ] && main "$@";:
