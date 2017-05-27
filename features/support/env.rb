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
end

After do
  FileUtils.cd PROJECT_DIR
  FileUtils.rm_r ENV['KICH_SRC']
  FileUtils.rm_r ENV['KICH_TGT']
end

$benchmarks = {}

Around('@benchmark') do |scenario, block|
  t = Time.now
  block.call
  $benchmarks[scenario.name] = Time.now - t
end

at_exit do
  next if $benchmarks.empty?

  FileUtils.mkdir_p BUILD_DIR
  file = File.join(BUILD_DIR, 'benchmark.json')
  IO.write file, JSON.generate(
    $benchmarks.map do |(key, value)|
      { name: key, value: value }
    end
  )
end
