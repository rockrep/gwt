#!/usr/bin/env ruby

require "rubygems"
require "bundler"
Bundler.setup

require "gmoney"

@u = YAML.load_file( "credentials.yml" )
GMoney::GFSession.login( @u["user"], @u["password"] )

puts "done"
