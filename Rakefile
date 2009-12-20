# require 'rake'
require 'rake/testtask'

desc 'Run tests by default'
task :default => :test

desc 'Test encoding utilities'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end