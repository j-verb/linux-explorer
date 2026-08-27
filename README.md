# linux-explorer

A command lookup tool for every command on your system.  Brief explanations are up front, with a chance to view commands with man, tdlr, or cheat.  

Currently still under construction but will run with the following commands:
chmod+ x linux-explorer
./linux-explorer <command>


A look-up tool for every command on your system.  Brief explanations up front with a chance to view commands more in depth.

## Testing

Run the automated test suite:

```bash
./run-tests.sh
```

The test runner covers:
- Bash syntax validation (`bash -n`)
- Missing argument behavior
- Unknown command behavior
- Interactive menu flows (`q`, `c`, `m`, `t`, invalid input)
- Fallback messages when `man` or `tldr` pages are unavailable
