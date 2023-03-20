# frozen_string_literal: true

RSpec.describe OpenlibClient do
  subject(:search) { described_class.search(title:) }
  let(:title) { 'title' }
  let(:http_response) { instance_double(Net::HTTPResponse, code: http_code, body: http_body) }
  let(:http_code) { '200' }
  let(:http_body) { { docs: [] }.to_json }

  before do
    allow(Net::HTTP).to receive(:get_response).and_return(http_response)
  end

  it 'sends HTTP request' do
    search
    target = URI('https://openlibrary.org/search.json?title=title&limit=10&fields=key%2Cauthor_name%2Ctitle')
    expect(Net::HTTP).to have_received(:get_response).with(target)
  end

  it 'returns empty response' do
    expect(search).to have_attributes(success: true, payload: [], error_message: nil)
  end

  context 'search payload' do
    let(:attributes) { { key: 'id', author_name: %w[author1 author2], title: 'The Title' } }
    let(:http_body) { { docs: [attributes] }.to_json }
    it 'wraps the payload' do
      expect(search.payload).to match_array(match(attributes))
    end
  end

  context 'empty params' do
    let(:title) { '  ' }

    it 'returns INVALID_ARGS' do
      expect(search).to eq(described_class::INVALID_ARGS)
    end
  end

  context 'missing params' do
    let(:title) { nil }

    it 'returns INVALID_ARGS' do
      expect(search).to eq(described_class::INVALID_ARGS)
    end
  end

  context 'non-200 response' do
    let(:http_code) { '429' }
    it 'returns INVALID_RESPONSE' do
      expect(search).to eq(described_class::INVALID_RESPONSE)
    end
  end

  context 'exception during HTTP call' do
    before { allow(Net::HTTP).to receive(:get_response).and_raise('Networking error') }

    it 'returns INTERNAL_SERVER_ERROR' do
      expect(search).to eq(described_class::INTERNAL_SERVER_ERROR)
    end
  end

  context 'invalid response structure' do
    let(:http_body) { { response: 'we upgraded our services' }.to_json }
    it 'return INVALID_RESPONSE' do
      expect(search).to eq(described_class::INVALID_RESPONSE)
    end
  end

  context 'broken JSON format' do
    let(:http_body) { 'gateway timeout' }
    it 'return INVALID_RESPONSE' do
      expect(search).to eq(described_class::INVALID_RESPONSE)
    end
  end
end
