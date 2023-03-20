# frozen_string_literal: true

require 'sinatra'
require 'haml'
require 'net/http'

require './app/openlib_client'
require './app/openlib_decorator'
require './app/openlib_service'

get '/' do
  haml :index
end

get '/search' do
  OpenlibService.search(title: params[:title]).to_json
rescue StandardError => e
  puts(message: 'Failed /search', error: e.detailed_message, trace: e.backtrace)
  [500, { success: false, error: 'Internal Server Error' }.to_json]
end
