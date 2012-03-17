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

config = {} unless config

if config && config['host']
  puts "\033[0;32mJira hostname in config.yml is already set to '#{config['host']}'"
else
  puts "\033[0;31mWARNING: Jira hostname is not set in config.yml\033[0;m"
  print "Please type in the hostname (e.g. jira.mycompany.com): "
  host = STDIN.gets.chomp
  host.slice! /^https?:\/\//
  host.slice! /\/?$/
  puts "\033[0;32mSetting the hostname in config.yml to '#{host}'"
  config['host'] = "#{host}"
end

if config && config['help_url']
  puts "\033[0;32mHelp URL in config.yml is already set to '#{config['help_url']}'"
else
  puts "\033[0;31mWARNING: Help URL is not set in config.yml\033[0;m"
  print "Please type in the help URL (e.g. http://help.mycompany.com/help.html): "
  help_url = STDIN.gets.chomp
  puts "\033[0;32mSetting the help file in config.yml to '#{help_url}'"
  config['help_url'] = "#{help_url}"
end

YAML.dump(config, cfile)