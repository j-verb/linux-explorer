# Linux Explorer

Linux Explorer is a small suite for exploring Linux commands and their reference material. It includes two terminal tools, `le-bash` and `linux-explorer`, plus the Tkinter desktop app `le-py`. The Debian package installs all three.

## le-bash

`le-bash` is a small, prompt-driven command inspector. Start it with a command name:

```bash
le-bash grep
```

It displays the command's resolved path and offers a menu to inspect:

| Choice | Action |
| --- | --- |
| `b` | Show `whereis`, file type, permissions, size, and dynamic-library information when available |
| `t` | Open the command's tldr page, if the tldr client is installed |
| `c` | Fetch the command's cheat sheet from cheat.sh; requires an internet connection |
| `m` | Open the local man page |
| `h` | Run the command with `--help` |
| `s` | Switch to another command to inspect |
| `q` | Quit |

The program uses `less` to page menu output. Its reference sources are independent: local man pages and `--help` do not need internet access, while cheat.sh does. tldr pages require a compatible `tldr` client and its local page cache.

If no command name is supplied, `le-bash` prints usage and exits:

```bash
le-bash <command>
```

## linux-explorer

`linux-explorer` is an interactive command lookup utility with a `whiptail` menu when available and a basic terminal-menu fallback otherwise. It refreshes a command-name index from the shell's available commands, then shows the selected command's path and `whatis` summary.

Run it with a command to inspect, or without an argument to choose from search:

```bash
linux-explorer grep
linux-explorer
```

The menu can open the command's man page or tldr page, query cht.sh, search for another installed command, switch to a command by name, or quit. Search uses `fzf` when installed; without it, the program prompts for a text filter. `whiptail`, `fzf`, and tldr are optional. At startup, the program offers to install missing menu/search/documentation tools using `apt` if available; decline to continue with the available fallback behavior.

The command index is written to `commands.txt` in the current working directory each time the program starts. Run it from a directory where creating or replacing that file is acceptable.

## le-py

`le-py` is a desktop GUI for command lookup, built with Python's standard Tkinter library. It provides a command entry with PATH-based completion, a status display for executable paths or shell built-ins, and a scrollable reference pane. The sidebar opens TLDR summaries, cheat.sh results, manual pages, executable `--help` output, and binary metadata. Online cheat sheets require an internet connection; TLDR pages require a compatible `tldr` client.

Start the GUI with an optional command name (it defaults to `ls`):

```bash
le-py
le-py grep
```

The command inventory is scanned from `$PATH` at startup and can be refreshed from the window. Like `linux-explorer`, `le-py` writes the inventory to `commands.txt` in the current working directory, replacing any existing file with that name. A graphical desktop session is required.

## Installation

### Debian and Ubuntu package

Tagged `v*` releases publish the Debian package and all three standalone programs on the [GitHub Releases page](https://github.com/j-verb/linux-explorer/releases). Install a downloaded package with:

```bash
sudo apt install ./linux-explorer_*_all.deb
```

The package installs `/usr/bin/le-bash`, `/usr/bin/linux-explorer`, and `/usr/bin/le-py`. It depends on Bash, Python 3 with Tkinter, `curl`, and `less`. To build the package from this source tree, install `debhelper` and `dpkg-dev`, then run:

```bash
dpkg-buildpackage -us -uc -b
```

The resulting `.deb` is written to the parent directory.

### Run from source

Clone the repository, make the programs executable, and invoke the tool you want:

```bash
git clone https://github.com/j-verb/linux-explorer.git
cd linux-explorer
chmod +x le-bash linux-explorer le-py
./le-bash grep
./linux-explorer grep
./le-py grep
```

## Requirements

Both Bash programs require Bash and `curl` for their online cheat-sheet lookups; `le-bash` also uses `less` for paging. `le-py` requires Python 3, Tkinter, and a graphical desktop session; it uses Python's standard library for HTTP requests. Optional reference tools include `whiptail`, `fzf`, a `tldr` client, `man`/`whatis`, `col`, `file`, and `whereis`. On Debian/Ubuntu, these are available from packages such as `python3-tk`, `whiptail`, `fzf`, `tealdeer`, `man-db`, `bsdextrautils`, `file`, and `util-linux`.

## Tests

Run the repository's shell test script with:

```bash
./run-tests.sh
```

Run the test script from the repository root.