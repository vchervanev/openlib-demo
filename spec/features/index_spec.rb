# frozen_string_literal: true

RSpec.describe 'index page' do
  it 'shows content' do
    visit '/'
    expect(page).to have_content 'Use Search to find books'
  end
end
