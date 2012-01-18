require "bundler/gem_tasks"

task :spec do
  status = system "rspec"
  exit status
end

desc "Run simplecov code coverage tool"
task :simplecov do
  ENV["COVERAGE"] = "true"
  Rake::Task["spec"].invoke
end

task :default => :spec

