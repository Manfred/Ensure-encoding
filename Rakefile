# encoding: utf-8

unless ''.respond_to?(:encoding)
  puts "[!] Sorry, but this code was written for Ruby 1.9 compatible implementations."
  exit 1
end

require 'rake/testtask'

desc 'Run specs by default'
task :default => :spec

desc 'Run all specs'
Rake::TestTask.new(:spec) do |t|
  t.libs << 'lib'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end