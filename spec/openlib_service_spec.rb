# frozen_string_literal: true

RSpec.describe OpenlibService do
  subject(:search) { described_class.search(title:) }
  let(:title) { 'title' }
  let(:client_response) do
    instance_double(OpenlibClient::Response, success:, payload:, error_message:)
  end
  let(:success) { true }
  let(:payload) { [{ key: '/key', author_name: %w[author1 author2], title: 'The Title' }] }
  let(:error_message) { nil }

  before do
    allow(OpenlibClient).to receive(:search).and_return(client_response)
  end

  it 'calls OpenlibClient' do
    expect(search).to match(success: true, payload: be_an(Array))
    expect(OpenlibClient).to have_received(:search).with(title:)
  end

  it 'decorates data' do
    result = have_attributes(title: 'The Title', authors: 'author1, author2', link: 'https://openlibrary.org/key')
    expect(search[:payload]).to match_array([result])
  end
end
