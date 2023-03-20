# frozen_string_literal: true

RSpec.describe 'search page' do
  it 'shows content' do
    visit '/search?title=lord+of+the+rings'
    expect(page.body).to include('{"title":"The Lord of the Rings","authors":"J.R.R. Tolkien","link":"https://openlibrary.org/works/OL27448W"}')
  end
end
