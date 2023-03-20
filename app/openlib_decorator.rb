# frozen_string_literal: true

# converts OpenlibClient's JSON response into FE-friendly Hash
class OpenlibDecorator
  Entry = Struct.new(:title, :authors, :link) do
    def initialize(title:, authors:, link:)
      super(title, authors, link)
    end

    def to_json(*_args)
      { title:, authors:, link: }.to_json
    end
  end

  # "key": "/works/OL27448W",
  # "title": "The Lord of the Rings",
  # "author_name": [
  #     "J.R.R. Tolkien"
  # ]
  def self.decorate(json)
    json.map do |rec|
      Entry.new(
        title: rec[:title],
        authors: rec[:author_name].join(', '),
        link: OpenlibClient::HOST + rec[:key]
      )
    end
  end
end
