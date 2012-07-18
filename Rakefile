require 'rake'
require 'rake/testtask'
require "bundler/gem_tasks"

desc 'Default: run unit tests.'
task :default => :test

desc 'Test nanoboy'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

def update_version(function, name)
  major, minor, tiny = File.read("VERSION").strip.split(".").map { |i| i.to_i }
  eval "#{name} #{function}= 1"
  File.open("VERSION", "w") { |f| f.puts [major, minor, tiny].join(".") }
  puts `cat VERSION`
end

{ :bump => "+", :debump => "-"}.each do |key, value|
  namespace key do
    [ :major, :minor, :tiny].each do |position|
      eval <<-CODE
      desc "#{key.to_s.capitalize} #{position} number by 1"
      task :#{position} do
        update_version("#{value}", "#{position}")
      end
    CODE
    end
  end
end
