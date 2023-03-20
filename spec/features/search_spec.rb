# frozen_string_literal: true

RSpec.describe 'search page' do
  scenario 'shows content' do
    visit '/search?title=lord+of+the+rings'
    expect(page.body).to include('{"title":"The Lord of the Rings","authors":"J.R.R. Tolkien","link":"https://openlibrary.org/works/OL27448W"}')
  end

  scenario 'failed query' do
    allow(OpenlibService).to receive(:search).and_raise('failed query')
    visit '/search?title=lord+of+the+rings'

    expect(page.body).to eq({ "success": false, "error": 'Internal Server Error' }.to_json)
  end
end
