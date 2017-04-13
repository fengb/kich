require 'test/unit/assertions'
require 'fileutils'
require 'tmpdir'

World(Test::Unit::Assertions)

WORK_DIR = File.expand_path('../..', __dir__)

Before do
  ENV['KICH_SRC'] = Dir.mktmpdir
  ENV['KICH_TGT'] = Dir.mktmpdir
end

After do
  FileUtils.cd WORK_DIR
  FileUtils.rm_r ENV['KICH_SRC']
  FileUtils.rm_r ENV['KICH_TGT']
end
