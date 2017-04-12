require 'fileutils'
require 'tmpdir'

Given "there are files in KICH_SRC:" do |string|
  string.each_line do |line|
    filepath = File.join(ENV['KICH_SRC'], line.strip)
    FileUtils.mkdir_p File.dirname(filepath)
    FileUtils.touch(filepath)
  end
end

When "I execute 'kich install'" do
  $output = `./kich install`
end

Then "there should be output:" do |string|
  expected = string.gsub(/\$KICH_TGT/, ENV['KICH_TGT'])
  fail $output if $output.strip != expected.strip
end

Then "there should be links in KICH_TGT:" do |string|
  string.each_line do |line|
    filepath = File.join(ENV['KICH_TGT'], line.strip)
    fail "#{filepath} is not a symlink" unless File.symlink? filepath
  end
end

Then "there should not be files in KICH_TGT:" do |string|
  string.each_line do |line|
    filepath = File.join(ENV['KICH_TGT'], line.strip)
    fail "#{filepath} exists" if File.exist? filepath
  end
end
