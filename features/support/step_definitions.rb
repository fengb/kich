require 'fileutils'
require 'open3'
require 'tempfile'

def env_expand(string)
  string.gsub(/\$([A-Z_]+)/) { ENV[$1] }
end

After do
  if $configfile
    $configfile.unlink
    $configfile = nil
  end
end

Given "I pry" do
  require 'pry'
  binding.pry
end

Given "in KICH_SRC" do
  FileUtils.cd ENV['KICH_SRC']
end

Given "in KICH_TGT" do
  FileUtils.cd ENV['KICH_TGT']
end

Given /there is a \$configfile with content:/ do |string|
  $configfile = Tempfile.new
  $configfile.write(string)
  $configfile.close
end

Given "there is a file '$file'" do |file|
  FileUtils.mkdir_p File.dirname(file)
  FileUtils.touch(file)
end

Given "there are $num files" do |num|
  num.to_i.times do |i|
    words = WORDS.sample(i % 3 + 3)
    step "there is a file '#{words.join('/')}'"
  end
end

Given "there are files:" do |files|
  files.each_line do |line|
    step "there is a file '#{line.strip}'"
  end
end

Given "there is a file '$file' with content:" do |file, contents|
  FileUtils.mkdir_p File.dirname(file)
  IO.write(file, contents)
end

When "I execute 'kich $args'" do |args|
  if $configfile
    args = args.gsub('$configfile', $configfile.path)
  end

  out, err, status = Open3.capture3(%Q[bash -c '"#{PROJECT_DIR}/bin/kich" #{args}'])
  $last_kich = { out: out, err: err, status: status }
end

Then "there should be output:" do |string|
  if $last_kich[:out].strip == ""
    fail $last_kich[:err]
  end
  assert_equal env_expand(string).strip, $last_kich[:out].strip
end

Then "there should be no output" do
  assert_equal "", $last_kich[:out].strip
end

Then "there should be error:" do |string|
  assert_equal string.strip, $last_kich[:err].strip
  assert_not_equal 0, $last_kich[:status]
end

Then "there should not be files:" do |files|
  files.each_line do |line|
    assert !File.exist?(line.strip)
  end
end

Then "there should be a file '$file' with content:" do |file, contents|
  assert_equal contents.strip, IO.read(file).strip
end

Then "there should be a symlink '$file' to '$target'" do |file, target|
  assert File.symlink?(file)
  assert_equal File.realpath(env_expand(target)), File.realpath(file)
end

Then "there should be symlinks:" do |table|
  table.raw.each do |(file, target)|
    step "there should be a symlink '#{file}' to '#{target}'"
  end
end
