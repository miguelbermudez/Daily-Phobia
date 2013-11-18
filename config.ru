require 'rubygems' 
require 'sass/plugin/rack'
require 'bundler' 

Bundler.require  
require './app' 

Sass::Plugin.options[:style] = :nested
use Sass::Plugin::Rack

run PhobiaApp
