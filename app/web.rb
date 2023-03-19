# frozen_string_literal: true

require 'sinatra'
require 'haml'
require 'JSON'
require 'net/http'

require './app/openlib_client'

get '/' do
  haml :index
end
