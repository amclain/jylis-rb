require "rspec/core/rake_task"
require "yard"

task :default => [:test]

desc "Run unit tests"
RSpec::Core::RakeTask.new :test

desc "Run integration tests"
task :integration do
  Dir.chdir("integration")

  exec "bundle exec rspec"
end

desc "Build the gem"
task :build => [:doc] do
  Dir["*.gem"].each {|file| File.delete file}
  system "gem build *.gemspec"
end

desc "Rebuild and [re]install the gem"
task :install => [:build] do
  system "gem install *.gem"
end

desc "Generate documentation"
YARD::Rake::YardocTask.new :doc do |task|
  task.options = %w(- README.md license.txt)
end
