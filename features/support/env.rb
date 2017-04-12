require 'fileutils'

Before do
  ENV['KICH_SRC'] = Dir.mktmpdir
  ENV['KICH_TGT'] = Dir.mktmpdir
end

After do
  FileUtils.rm_r ENV['KICH_SRC']
  FileUtils.rm_r ENV['KICH_TGT']
end
