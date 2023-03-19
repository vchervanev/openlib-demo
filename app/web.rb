# frozen_string_literal: true

require 'sinatra'
require 'haml'

get '/' do
  haml :index
end
