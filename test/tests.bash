dir="`dirname "${BASH_SOURCE[0]}"`"

source "$dir/../kich"

__=$'\n'

test_or_names() {
  assert_equals "-name${__}foo" \
                "`or_names <<<foo`"

  assert_equals "-name${__}foo bar" \
                "`or_names <<<'foo bar'`"

  assert_equals "-name${__}foo${__}-or${__}-name${__}bar" \
                "`or_names <<<"foo${__}bar"`"
}

test_abspath() {
  assert_equals "$PWD/foo" \
                "`abspath "foo"`"

  assert_equals "${PWD%/*}/foo" \
                "`abspath "../foo"`"
}

test_find_filter() {
  assert_equals "${BASH_SOURCE[0]}" \
                "`find_filter ${BASH_SOURCE[0]}`"
  assert_equals "${BASH_SOURCE[0]}" \
                "`find_filter ${BASH_SOURCE[0]} -type f`"
  assert_equals "" \
                "`find_filter ${BASH_SOURCE[0]} -type d`"
}

test_rm_files() {
  tmp="`mktemp`"
  assert "yes | rm_files 3<<<"$tmp""
  assert "[ ! -e $tmp ]"

  tmp="`mktemp`"
  assert "<<<yes rm_files 3<<<"$tmp""
  assert "[ ! -e $tmp ]"

  tmp="`mktemp`"
  assert_fail "<<<no rm_files 3<<<"$tmp""
  assert "[ -e $tmp ]"

  assert_equals "$tmp" \
                "`yes | rm_files 3<<<"$tmp"`"
  assert "[ ! -e $tmp ]"
}
