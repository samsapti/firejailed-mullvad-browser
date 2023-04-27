# Backported profiles

If you want to use a stable firejail version rather then the latest git,
you must use profiles with no features added in later versions.


## Using stable-profiles

Call `./install.sh` with `--firejail=VERSION`, e.g.

```bash
$ ./install.sh --firejail=0.9.60 ~/Downloads/mullvad-browser-linux64-*_ALL.tar.xz
```

or, if you use the manual install, download the profile and the `.desktop` file for
your firejail version instead of the files from the repo-root.

For other special aspects, see the README of the respective version.
