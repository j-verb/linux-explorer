#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/linux-explorer"

pass_count=0
fail_count=0

log_pass() {
    printf "PASS: %s\n" "$1"
    pass_count=$((pass_count + 1))
}

log_fail() {
    printf "FAIL: %s\n" "$1"
    fail_count=$((fail_count + 1))
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local label="$3"

    if grep -Fq "$needle" <<<"$haystack"; then
        log_pass "$label"
    else
        log_fail "$label"
        printf "  Expected to find: %s\n" "$needle"
        printf "  Output was:\n%s\n" "$haystack"
    fi
}

assert_exit_code() {
    local got="$1"
    local want="$2"
    local label="$3"

    if [[ "$got" == "$want" ]]; then
        log_pass "$label"
    else
        log_fail "$label"
        printf "  Expected exit code %s but got %s\n" "$want" "$got"
    fi
}

make_mock_bin() {
    local mock_bin
    mock_bin="$(mktemp -d)"

    cat >"$mock_bin/curl" <<'EOF'
#!/usr/bin/env bash
cat <<'TEXT'
# header to strip

example one
example two
TEXT
EOF

    cat >"$mock_bin/man" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF

    cat >"$mock_bin/tldr" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF

    chmod +x "$mock_bin/curl" "$mock_bin/man" "$mock_bin/tldr"
    printf "%s" "$mock_bin"
}

run_case() {
    local label="$1"
    local input="$2"
    local command_name="$3"
    local output=""
    local code=0

    set +e
    output="$(printf "%b" "$input" | PATH="$MOCK_BIN:$PATH" bash "$SCRIPT" "$command_name" 2>&1)"
    code=$?
    set -e

    LAST_OUTPUT="$output"
    LAST_CODE="$code"
    printf "\nCase: %s\n" "$label"
}

run_no_arg_case() {
    local output=""
    local code=0

    set +e
    output="$(PATH="$MOCK_BIN:$PATH" bash "$SCRIPT" 2>&1)"
    code=$?
    set -e

    LAST_OUTPUT="$output"
    LAST_CODE="$code"
    printf "\nCase: no-arg usage\n"
}

run_unknown_case() {
    local output=""
    local code=0

    set +e
    output="$(PATH="$MOCK_BIN:$PATH" bash "$SCRIPT" definitelynotarealcommand 2>&1)"
    code=$?
    set -e

    LAST_OUTPUT="$output"
    LAST_CODE="$code"
    printf "\nCase: unknown command\n"
}

MOCK_BIN="$(make_mock_bin)"
trap 'rm -rf "$MOCK_BIN"' EXIT

printf "Running syntax check...\n"
set +e
SYNTAX_OUTPUT="$(bash -n "$SCRIPT" 2>&1)"
SYNTAX_CODE=$?
set -e
assert_exit_code "$SYNTAX_CODE" "0" "bash syntax check"
if [[ -n "$SYNTAX_OUTPUT" ]]; then
    printf "%s\n" "$SYNTAX_OUTPUT"
fi

run_no_arg_case
assert_exit_code "$LAST_CODE" "1" "no args exits 1"
assert_contains "$LAST_OUTPUT" "Usage: ./linux-explorer <command>" "no args prints usage"

run_unknown_case
assert_exit_code "$LAST_CODE" "1" "unknown command exits 1"
assert_contains "$LAST_OUTPUT" "was not found" "unknown command message"

run_case "quit path" "q\n" "ls"
assert_exit_code "$LAST_CODE" "0" "quit path exits 0"
assert_contains "$LAST_OUTPUT" "Command: ls" "shows command header"
assert_contains "$LAST_OUTPUT" "Shutting down" "quit message"

run_case "cheat examples" "c\nq\n" "ls"
assert_exit_code "$LAST_CODE" "0" "cheat path exits 0"
assert_contains "$LAST_OUTPUT" "Cheat examples:" "cheat section label"
assert_contains "$LAST_OUTPUT" "example one" "cheat output line one"
assert_contains "$LAST_OUTPUT" "example two" "cheat output line two"

run_case "man fallback" "m\nq\n" "ls"
assert_exit_code "$LAST_CODE" "0" "man fallback exits 0"
assert_contains "$LAST_OUTPUT" "No man page found for 'ls'." "man fallback message"

run_case "tldr fallback" "t\nq\n" "ls"
assert_exit_code "$LAST_CODE" "0" "tldr fallback exits 0"
assert_contains "$LAST_OUTPUT" "No tldr page found for 'ls'." "tldr fallback message"

run_case "invalid choice" "x\nq\n" "ls"
assert_exit_code "$LAST_CODE" "0" "invalid choice still allows quit"
assert_contains "$LAST_OUTPUT" "Invalid choice." "invalid choice message"

printf "\nSummary: %d passed, %d failed\n" "$pass_count" "$fail_count"

if [[ "$fail_count" -gt 0 ]]; then
    exit 1
fi
