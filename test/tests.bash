DIR="`dirname "${BASH_SOURCE[0]}"`"

source "$DIR/../kich"

__=$'\n'

test_or_names() {
  assert_equals "`or_names <<<foo`" "-name${__}foo"
}
