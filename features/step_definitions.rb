require 'fileutils'

def expand(string)
  string.gsub(/\$KICH_TGT/, ENV['KICH_TGT'])
        .gsub(/\$KICH_SRC/, ENV['KICH_SRC'])
end

Given "in KICH_SRC there are files:" do |files|
  FileUtils.cd ENV['KICH_SRC'] do
    files.each_line do |line|
      file = line.strip
      FileUtils.mkdir_p File.dirname(file)
      FileUtils.touch(file)
    end
  end
end

Given "in KICH_TGT there is a file '$file' with content:" do |file, contents|
  FileUtils.cd ENV['KICH_TGT'] do
    FileUtils.mkdir_p File.dirname(file)
    IO.write(file, contents)
  end
end

When "I execute 'kich $command'" do |command|
  $output = `./kich #{command}`
end

Then "there should be output:" do |string|
  assert_equal expand(string).strip, $output.strip
end

Then "there should be no output" do
  assert_equal "", $output.strip
end

Then "in KICH_TGT there should not be files:" do |files|
  FileUtils.cd ENV['KICH_TGT'] do
    files.each_line do |line|
      assert !File.exist?(line.strip)
    end
  end
end

Then "in KICH_SRC there should be a file '$file' with content:" do |file, contents|
  FileUtils.cd ENV['KICH_SRC'] do
    assert_equal contents.strip, IO.read(file).strip
  end
end

Then "in KICH_TGT there should be a symlink '$filename' to '$target'" do |file, target|
  FileUtils.cd ENV['KICH_TGT'] do
    assert File.symlink?(file)
    assert_equal File.realpath(expand(target)), File.realpath(file)
  end
end

Then "in KICH_TGT there should be symlinks:" do |table|
  FileUtils.cd ENV['KICH_TGT'] do
    table.raw.each do |(file, target)|
      assert File.symlink?(file)
      assert_equal File.realpath(expand(target)), File.realpath(file)
    end
  end
end
