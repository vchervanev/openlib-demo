# frozen_string_literal: true

# OpenLibrary.org Client
class OpenlibClient
  Response = Struct.new(:success, :payload, :error_message)

  HOST = 'https://openlibrary.org'
  URL = "#{HOST}/search.json".freeze
  DEFAULT_FIELDS = %w[key author_name title].join(',')
  SCHEMA = {
    key: ->(v) { v.is_a?(String) && v.strip != '' },
    title: ->(v) { v.is_a?(String) && v.strip != '' },
    author_name: ->(v) { v.is_a?(Array) && v.all? { |item| item.is_a?(String) && item.strip != '' } }
  }.freeze
  INVALID_ARGS = Response.new(false, nil, 'invalid request: title is requied')
  INVALID_RESPONSE = Response.new(false, nil, 'invalid provider response: unable to fetch data')
  INTERNAL_SERVER_ERROR = Response.new(false, nil, 'Internal server error')

  class << self
    def search(title:, limit: 10, fields: DEFAULT_FIELDS)
      return INVALID_ARGS if title.strip.to_s == ''

      response = get(title:, limit:, fields:)
      if response.code != '200'
        puts(message: 'non 200 GET response', code: response.code, body: response.body)
        return INVALID_RESPONSE
      end

      parse_search_response(response.body)
    rescue StandardError => e
      puts(message: 'failed GET', error: e.detailed_message, trace: e.backtrace)
      INTERNAL_SERVER_ERROR
    end

    private

    def get(query = {})
      uri = URI(URL).tap do |request|
        request.query = URI.encode_www_form(query)
      end

      Net::HTTP.get_response(uri)
    end

    def parse_search_response(body)
      json = JSON.parse(body, symbolize_names: true)

      unless valid_schema?(json)
        puts(message: 'unexpected JSON schema', json:)
        return INVALID_RESPONSE
      end

      Response.new(true, json[:docs], nil)
    rescue JSON::ParserError => e
      puts(message: 'unable to parse JSON response', error: e.detailed_message, trace: e.backtrace)
      INVALID_RESPONSE
    end

    def valid_schema?(json)
      return false unless json.is_a?(Hash) && json[:docs].is_a?(Array)

      json[:docs].all? do |rec|
        rec.is_a?(Hash) && SCHEMA.each do |key, validator|
          rec.key?(key) && validator.call(rec[key])
        end
      end
    end
  end
end
