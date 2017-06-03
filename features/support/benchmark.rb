$benchmarks = []

AfterStep('@benchmark') do |scenario, step|
  $prev = $curr
  $curr = Time.now
end

After('@benchmark') do |scenario|
  $benchmarks << { name: scenario.name, value: Time.now - $prev }
end

at_exit do
  next if $benchmarks.empty?

  FileUtils.mkdir_p BUILD_DIR
  file = File.join(BUILD_DIR, 'benchmark.json')
  IO.write file, JSON.pretty_generate($benchmarks)
end
