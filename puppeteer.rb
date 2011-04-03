#!/usr/bin/ruby -rubygems

require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'sass'
require './lib/couch'
require './lib/node'
require './lib/class'
require './lib/terminus'

set :haml, :format => :html5 # default Haml format is :xhtml
server = Couch::Server.new("localhost", "5984")


# Index
get '/' do
  @page = "Home"
  haml :index
end

# Help
get '/help' do
  @page = "Help"
  haml :help
end

get '/stylesheet.css' do
  sass :stylesheet
end
