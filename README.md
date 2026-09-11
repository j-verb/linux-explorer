# Linux Explorer 🚀

[![Build Status](https://github.com)](https://github.com)

An interactive, text-based terminal dashboard tool built in pure Bash to quickly look up commands, reference system manuals, and view live formatting cheat-sheet summary guides natively.

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
```

### Method 2: Global Manual Installation (Universal Linux)

If you prefer to install it directly from the source code via the system Makefile layout:

```bash
git clone https://github.com
cd linux-explorer
sudo make install
```

---

## 📖 Usage Instructions

Once installed, you can invoke the explorer binary globally from any folder channel by passing your targeted linux command argument:

```bash
linux-explorer grep
```

### 🧭 Options Menu Controls
When the dashboard initializes, use these interactive keyboard shortcuts to pull up information tracks:
* Press **`m`** to open the official local system `man` page.
* Press **`t`** to stream quick `tldr` community example summaries.
* Press **`c`** to query the online `cht.sh` console repository stream.
* Press **`n`** to enter and assign a brand-new command instance dynamically.
* Press **`q`** to safely close the utility console.

---

## 🧼 Uninstallation

To remove the application bundle cleanly from your local file system at any time, run:

```bash
sudo make uninstall
```
