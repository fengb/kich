require 'fileutils'

def expand(string)
  string.gsub(/\$KICH_TGT/, ENV['KICH_TGT'])
        .gsub(/\$KICH_SRC/, ENV['KICH_SRC'])
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

Given "there is a file '$file'" do |file|
  FileUtils.mkdir_p File.dirname(file)
  FileUtils.touch(file)
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

When "I execute 'kich $command'" do |command|
  $output = `"#{WORK_DIR}/kich" #{command}`
end

Then "there should be output:" do |string|
  assert_equal expand(string).strip, $output.strip
end

Then "there should be no output" do
  assert_equal "", $output.strip
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
  assert_equal File.realpath(expand(target)), File.realpath(file)
end

Then "there should be symlinks:" do |table|
  table.raw.each do |(file, target)|
    step "there should be a symlink '#{file}' to '#{target}'"
  end
end