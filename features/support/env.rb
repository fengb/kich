require 'test/unit/assertions'
require 'fileutils'
require 'tmpdir'
require 'json'

World(Test::Unit::Assertions)

PROJECT_DIR = File.expand_path('../../..', __FILE__)
BUILD_DIR = File.join(PROJECT_DIR, 'build')

Before do
  ENV['KICH_SRC'] = Dir.mktmpdir
  ENV['KICH_TGT'] = Dir.mktmpdir
  ENV['KICH_CACHE'] = Tempfile.new("kich-cache").tap(&:close).path
end

After do
  FileUtils.cd PROJECT_DIR
  FileUtils.rm_r ENV['KICH_SRC']
  FileUtils.rm_r ENV['KICH_TGT']
  FileUtils.rm ENV['KICH_CACHE']
end
