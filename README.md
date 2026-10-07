# Linux Explorer

Linux Explorer is a pair of Bash command-line tools for looking up installed Linux commands and opening their reference material. The Debian package installs both programs: `le-bash` and `linux-explorer`.

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

## Installation

### Debian and Ubuntu package

Tagged `v*` releases publish the Debian package and both standalone scripts on the [GitHub Releases page](https://github.com/j-verb/linux-explorer/releases). Install a downloaded package with:

```bash
sudo apt install ./linux-explorer_*_all.deb
```

The package installs `/usr/bin/le-bash` and `/usr/bin/linux-explorer`. To build the package from this source tree, install `debhelper` and `dpkg-dev`, then run:

```bash
dpkg-buildpackage -us -uc -b
```

The resulting `.deb` is written to the parent directory.

### Run from source

Clone the repository, make both scripts executable, and invoke either one:

```bash
git clone https://github.com/j-verb/linux-explorer.git
cd linux-explorer
chmod +x le-bash linux-explorer
./le-bash grep
./linux-explorer grep
```

## Requirements

Both programs require Bash and `curl` for their online cheat-sheet lookup. `le-bash` also requires `less` for paging. `linux-explorer` works best with `whiptail` and `fzf`; its reference actions can use `man`/`whatis`, tldr, and `curl` for cht.sh. Optional utilities used by `le-bash` include `file`, `whereis`, `man`, and `col`. On Debian/Ubuntu, these are provided by packages including `whiptail`, `fzf`, `tealdeer`, `man-db`, `bsdextrautils`, `file`, and `util-linux`.

## Tests

Run the repository's shell test script with:

```bash
./run-tests.sh
```

Run the test script from the repository root.