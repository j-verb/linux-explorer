#!/usr/bin/env bash

# Test suite for linux-explorer
TARGET="./linux-explorer"
PASSED=0
FAILED=0

# Ensure target script exists and is executable
if [[ ! -x "$TARGET" ]]; then
    chmod +x "$TARGET" 2>/dev/null || {
        echo "Error: $TARGET not found or cannot be made executable."
        exit 1
    }
fi

run_test() {
    local test_name="$1"
    local expected_pattern="$2"
    local expected_status="$3"
    shift 3
    local cmd=("$@")

    echo -n "Running: $test_name ... "
    output=$("${cmd[@]}" 2>&1)
    status=$?

    local pass=true
    if [[ -n "$expected_status" && "$status" -ne "$expected_status" ]]; then
        pass=false
    fi

    if [[ -n "$expected_pattern" ]] && ! echo "$output" | grep -Eq "$expected_pattern"; then
        pass=false
    fi

    if [[ "$pass" == true ]]; then
        echo -e "\e[32mPASS\e[0m"
        ((PASSED++))
    else
        echo -e "\e[31mFAIL\e[0m"
        echo "  [Exit Status] Expected: ${expected_status:-any}, Got: $status"
        echo "  [Expected Pattern]: $expected_pattern"
        echo "  [Actual Output]:"
        echo "$output" | sed 's/^/    /'
        ((FAILED++))
    fi
}

echo "=========================================="
echo " Starting Automated Tests for linux-explorer"
echo "=========================================="

# Test 1: Missing command argument exits with error and prints usage
run_test "Missing argument exits with status 1" \
         "Usage: ./linux-explorer <command>" \
         1 \
         "$TARGET"

# Test 2: Non-existent system command exits with error
run_test "Invalid command lookup exits with status 1" \
         "was not found in system command binaries index" \
         1 \
         "$TARGET" "definitely_not_a_valid_command_12345"

# Test 3: Valid command initialization and clean quit [q]
run_test "Valid command init and clean quit (q)" \
         "Shutting down linux-explorer utility safely" \
         0 \
         bash -c "printf 'q\n' | $TARGET ls"

# Test 4: Invalid menu choice feedback
run_test "Invalid menu input handling" \
         "Invalid option mapping selected" \
         0 \
         bash -c "printf 'z\nq\n' | $TARGET ls"

# Test 5: Switch command feature [n] with valid command
run_test "Switch command (n) to valid command" \
         "ACTIVE EXPLORER INTERFACE: grep" \
         0 \
         bash -c "printf 'n\ngrep\nq\n' | $TARGET ls"

# Test 6: Switch command feature [n] with invalid command
run_test "Switch command (n) to invalid command" \
         "binary validation failed" \
         0 \
         bash -c "printf 'n\ninvalid_cmd_xyz\nq\n' | $TARGET ls"

# Test 7: Trigger cheat sheet option [c]
run_test "Cheat sheet trigger (c)" \
         "Querying cht.sh online console repository" \
         0 \
         bash -c "printf 'c\nq\n' | $TARGET ls"

echo "=========================================="
echo "Test Summary: $PASSED Passed, $FAILED Failed"
echo "=========================================="

if (( FAILED > 0 )); then
    exit 1
fi
exit 0