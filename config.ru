require 'rubygems'
require 'bundler'
require 'sinatra'
require './main.rb'

Bundler.setup

run ReleaseDashboard::Application