# frozen_string_literal: true

# combines OpenlibClient and OpenlibDecorator into a single Web Service
class OpenlibService
  class << self
    def search(title:)
      result = OpenlibClient.search(title:)

      payload = (OpenlibDecorator.decorate(result.payload) if result.success)

      {
        success: result.success,
        payload:,
        error: result.error_message
      }.compact
    end
  end
end
