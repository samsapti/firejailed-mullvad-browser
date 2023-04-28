# HOW TO: Firejailed Mullvad Browser

**Note:** This is a fork of [firejailed-tor-browser](https://github.com/rusty-snake/firejailed-tor-browser)
by rusty-snake. This fork is for Firejailing [Mullvad Browser](https://mullvad.net/browser) instead of Tor Browser.

  * Install [firejail](https://firejail.wordpress.com/) ([repo](https://github.com/netblue30/firejail)) latest git, or if you are using a stable firejail release,
    have a look at [stable-profiles](stable-profiles).
  * Download [Mullvad Browser](https://mullvad.net/download/browser)
  * Verify the signature as described [here](https://mullvad.net/en/help/verifying-mullvad-browser-signature).
  * Execute the `install.sh` script in a terminal:
    ```bash
    $ ./install.sh ~/Downloads/mullvad-browser-linux64-*_ALL.tar.xz
    ```
    Or do the following steps:
    * Create `${HOME}/.firejailed-mullvad-browser` and extract Mullvad Browser to it.
    * Create `${HOME]/.firejailed-mullvad-browser/Data` and `${HOME}/.firejailed-mullvad-browser/UpdateInfo`
    * Copy the `firejailed-mullvad-browser.profile` file from this repo to `$HOME/.config/firejail/firejailed-mullvad-browser.profile`.
    * Copy the `firejailed-mullvad-browser.desktop.in` file from this repo to `$HOME/.local/share/applications/firejailed-mullvad-browser.desktop` and replace each occurrence of the string HOME with the content of `$HOME`.
    * Add `blacklist ${HOME}/.firejailed-mullvad-browser` to `$HOME/.config/firejail/disable-programs.local`
    * **Summary**
      ```bash
      $ mkdir $HOME/.firejailed-mullvad-browser/{,Data,UpdateInfo}
      $ tar -C "$HOME/.firejailed-mullvad-browser" --strip 1 -xJf ~/Downloads/mullvad-browser-linux64-*_ALL.tar.xz
      $ wget -O "$HOME/.config/firejail/firejailed-mullvad-browser.profile" "https://raw.githubusercontent.com/samsapti/firejailed-mullvad-browser/master/firejailed-mullvad-browser.profile"
      $ wget -O- "https://raw.githubusercontent.com/samsapti/firejailed-mullvad-browser/master/firejailed-mullvad-browser.desktop.in" | sed "s;HOME;$HOME;g" > "$HOME/.local/share/applications/firejailed-mullvad-browser.desktop"
      $ echo 'blacklist ${HOME}/.firejailed-mullvad-browser' >> "${HOME}/.config/firejail/disbale-programs.local"
      ```
  * Now you can start Mullvad Browser from your Desktop Environment or by running `firejail --profile=firejailed-mullvad-browser "$HOME/Browser/start-mullvad-browser"`.
  * Additionally, you can restrict the available interfaces with the `net` command.
    * List all interfaces: `ip addr show` or `ifconfig`
    * Add the interface with your internet connection to `firejailed-mullvad-browser.local`
    * Example: `echo 'net wlan0' >> "${HOME}/.config/firejail/firejailed-mullvad-browser.local"`
  * Tor Browser 10.5 added Wayland support (Mullvad Browser is based on Tor Browser). `firejailed-mullvad-browser.profile` enables the use of the wayland backend and blocks access to X11.
    If you still rely on X11, you need to run `install.sh`/`update.sh` with `--x11` or add the following to your `firejailed-mullvad-browser.local`:
    ```
    include firejailed-mullvad-browser-x11.inc
    ```

--------------------

License: [MIT](LICENSE)
