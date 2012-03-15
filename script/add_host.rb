#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'

cpath = File.expand_path('../../config.yml', __FILE__)
cfile = if File.exists? cpath
          File.open(cpath, 'r+')
        else
          File.open(cpath, File::WRONLY|File::CREAT|File::EXCL)
        end
config = YAML.load_file(cfile)

if ARGV[0] == "1"
  puts "\033[0;31mOverwriting config.yml\033[0;m"
  config = nil
end

if config && config['host']
  puts "\033[0;32mJira hostname in config.yml is already set to '#{config['host']}'"
else
  config = {}
  puts "\033[0;31mWARNING: Jira hostname is not set in config.yml\033[0;m"
  print "Please type in the hostname (e.g. jira.mycompany.com): "
  host = STDIN.gets.chomp
  host.slice! /^https?:\/\//
  host.slice! /\/?$/
  puts "\033[0;32mSetting the hostname in config.yml to '#{host}'"
  config['host'] = host
  YAML.dump(config, cfile)
end