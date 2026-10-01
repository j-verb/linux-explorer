# Linux Explorer 🚀

[![Build Status](https://github.com)](https://github.com)

An interactive terminal dashboard tool built in pure Bash to quickly lookup commands, reference system manuals, view syntax-highlighted cheat sheets, search system binaries interactively, and test commands directly within a clean TUI interface.

---

## ✨ Features

* **⌨️ Interactive TUI Navigation:** Driven by `whiptail` with full arrow-key and menu support.
* **🔍 Fuzzy Command Search:** Integrated `fzf` search bar with fallback terminal filtering.
* **⚡ Live Dependency Management:** Automatically detects and prompts to install missing prerequisites (`whiptail`, `fzf`, `bat`, `tealdeer/tldr`).
* **🎨 Syntax Highlighting:** Colorized output for cheat sheets and summary banners via `bat`.
* **⚙️ Direct Command Execution:** Test binaries with custom flags/arguments directly from inside the session.
* **📚 Self-Healing Documentation Cache:** Automatic detection and cache population for `tldr`/`tealdeer`.

---

## 🛠️ Installation

You can install `linux-explorer` natively on your system using one of the two methods below.

### Method 1: Install the Native `.deb` Package (Recommended for Debian/Ubuntu)

Every time an official release is tagged, a pre-compiled Debian package is automatically built and attached to our release pipeline.

1. Go to the **[Releases](https://github.com)** page on the right-hand sidebar.
2. Download the latest `.deb` file (e.g., `linux-explorer_1.0.1-1_all.deb`).
3. Run the following command in your terminal to install it cleanly:

```bash
sudo apt install ./linux-explorer_*_all.deb