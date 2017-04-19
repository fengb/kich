__dir__="`dirname "${BASH_SOURCE[0]}"`"
__file__="`basename "${BASH_SOURCE[0]}"`"

source "$__dir__/../kich"

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
  assert_equals "$__file__" \
                "`find_filter $__file__`"
  assert_equals "$__file__" \
                "`find_filter $__file__ -type f`"
  assert_equals "" \
                "`find_filter $__file__ -type d`"
}

test_rm_files() {
  tmp="`mktemp`"
  assert "yes | rm_files 3<<<\"$tmp\""
  assert "[ ! -e $tmp ]"

  tmp="`mktemp`"
  assert "<<<yes rm_files 3<<<\"$tmp\""
  assert "[ ! -e $tmp ]"

  tmp="`mktemp`"
  <<<no rm_files 3<<<"$tmp"
  assert "[ -e $tmp ]"

  assert_equals "✗  $tmp" \
                "`yes | rm_files 3<<<"$tmp"`"
  assert "[ ! -e $tmp ]"
}
