DIR="`dirname "${BASH_SOURCE[0]}"`"

source "$DIR/../kich"

__=$'\n'

test_or_names() {
  assert_equals "`or_names <<<foo`" "-name${__}foo"
  assert_equals "`or_names <<<'foo bar'`" "-name${__}foo bar"
  assert_equals "`or_names <<<"foo${__}bar"`" "-name${__}foo${__}-or${__}-name${__}bar"
}
