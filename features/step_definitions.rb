require 'fileutils'
require 'tmpdir'

Given "in KICH_SRC there are files:" do |string|
  string.each_line do |line|
    filepath = File.join(ENV['KICH_SRC'], line.strip)
    FileUtils.mkdir_p File.dirname(filepath)
    FileUtils.touch(filepath)
  end
end

Given "in KICH_TGT there is a file '$filename' with content:" do |filename, contents|
  filepath = File.join(ENV['KICH_TGT'], filename)
  FileUtils.mkdir_p File.dirname(filepath)
  IO.write(filepath, contents)
end

When "I execute 'kich $command'" do |command|
  $output = `./kich #{command}`
end

Then "there should be output:" do |string|
  expected = string.gsub(/\$KICH_TGT/, ENV['KICH_TGT'])
  fail $output if $output.strip != expected.strip
end

Then "there should be no output" do
  fail $output if $output.strip.size > 0
end

Then "in KICH_TGT there should not be files:" do |string|
  string.each_line do |line|
    filepath = File.join(ENV['KICH_TGT'], line.strip)
    fail "#{filepath} exists" if File.exist? filepath
  end
end

Then "in KICH_SRC there should be a file '$filename' with content:" do |filename, contents|
  filepath = File.join(ENV['KICH_SRC'], filename.strip)
  actual = IO.read filepath
  fail actual if actual.strip != contents.strip
end

Then "in KICH_TGT there should be a symlink '$filename'" do |filename|
  filepath = File.join(ENV['KICH_TGT'], filename.strip)
  fail "#{filepath} is not a symlink" unless File.symlink? filepath
end

Then "in KICH_TGT there should be symlinks:" do |string|
  string.each_line do |line|
    step "in KICH_TGT there should be a symlink '#{line.strip}'"
  end
end
