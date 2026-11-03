# Linux Explorer

`linux-explorer` is an interactive terminal utility for finding installed
commands and opening their local or online reference material. It uses a
`whiptail` menu when available and a basic terminal menu otherwise.

## Usage

Run it with a command to inspect, or without an argument to search:

```bash
linux-explorer grep
linux-explorer
```

The menu can open a command's man page or TLDR page, query cht.sh, search for
another installed command, switch to a command by name, or quit. Search uses
`fzf` when installed and falls back to a text filter otherwise. At startup,
the program offers to install missing `whiptail`, `fzf`, or TLDR tools with
`apt` when available; decline to continue without them.

The command index is written to `commands.txt` in the current working
directory each time the program starts. Run it from a directory where
creating or replacing that file is acceptable.

## Installation

Tagged `v*` releases publish the standalone program and Debian package on the
[GitHub Releases page](https://github.com/j-verb/linux-explorer/releases).
Install a downloaded package with:

```bash
sudo apt install ./linux-explorer_*.deb
```

The package installs `/usr/bin/linux-explorer` and depends on Bash and `curl`.
To build it from source on Debian or Ubuntu, install `debhelper` and `dpkg-dev`,
then run:

```bash
dpkg-buildpackage -us -uc -b
```

The resulting `.deb` is written to the parent directory.

To run from a source clone:

```bash
git clone https://github.com/j-verb/linux-explorer.git
cd linux-explorer
chmod +x linux-explorer
./linux-explorer grep
```

## Requirements

Bash and `curl` are required. Optional tools include `whiptail`, `fzf`, a
`tldr` client, and `man`/`whatis`; on Debian or Ubuntu these are available from
packages such as `whiptail`, `fzf`, `tealdeer`, and `man-db`. Online cheat
sheets require an internet connection.

The other command inspectors are maintained separately: [le-bash](https://github.com/j-verb/linux-explorer---bash-only)
and [le-py](https://github.com/j-verb/linux-explorer---python).

## Tests

Run the shell test script from the repository root:

```bash
./run-tests.sh
```
