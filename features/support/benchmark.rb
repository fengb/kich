$benchmarks = {}

Before('@benchmark') do |scenario|
  $scenario_name = scenario.name
end

Then "I benchmark '$cmd'" do |cmd|
  start = Time.now
  step "I execute '#{cmd}'"
  $benchmarks[$scenario_name] = Time.now - start
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
