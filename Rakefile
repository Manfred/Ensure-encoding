# encoding: utf-8

unless ''.respond_to?(:encoding)
  puts "[!] Sorry, but this code was written for Ruby 1.9 compatible implementations."
  exit 1
end

require 'rake/testtask'

desc 'Run tests by default'
task :default => :test

desc 'Test encoding utilities'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end