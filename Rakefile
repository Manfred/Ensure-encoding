# encoding: utf-8

unless ''.respond_to?(:encoding)
  puts "[!] Sorry, but this code was written for Ruby 1.9 compatible implementations."
  exit 1
end

require 'rake/rdoctask'
require 'rbconfig'

desc 'Run specs by default'
task :default => :spec

desc 'Run all specs'
task :spec do
  ruby = File.join(*Config::CONFIG.values_at('bindir', 'ruby_install_name'))
  sh "#{ruby} spec/**/*_spec.rb"
end

namespace :documentation do
  Rake::RDocTask.new(:generate) do |rd|
    rd.main = "README.rdoc"
    rd.rdoc_files.include("README.rdoc", "LICENSE", "lib/**/*.rb")
    rd.options << "--all" << "--charset" << "utf-8"
  end
end

namespace :gem do
  desc "Build the gem"
  task :build do
    sh 'gem build ensure-encoding.gemspec'
  end
  
  task :install => :build do
    sh 'gem install ensure-encoding-*.gem'
  end
end
