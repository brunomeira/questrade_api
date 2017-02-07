require 'spec_helper'

require 'questrade_api/authorization'

describe QuestradeApi::Authorization do
  let(:access_token) { 'XXXX' }
  let(:api_server) { 'http://test.com' }
  let(:expires_in) { 123 }
  let(:refresh_token) { 'AAAAA' }
  let(:token_type) { 'refresh_token' }
  let(:data) do
    {
      access_token: access_token,
      api_server: api_server,
      expires_in: expires_in,
      refresh_token: refresh_token,
      token_type: token_type
    }
  end

  context '#initialize' do
    it 'only accepts :live or :practice mode' do
      expect { QuestradeApi::Authorization.new(data) }.to_not raise_error
      expect { QuestradeApi::Authorization.new(data, :practice) }.to_not raise_error
      expect { QuestradeApi::Authorization.new(data, :live) }.to_not raise_error

      expect { QuestradeApi::Authorization.new(data, :other) }.to raise_error('Mode must be :live or :practice')
    end

    it 'populates attributes accordingly with practice mode as default' do
      subject = QuestradeApi::Authorization.new(data)

      expect(subject.mode).to eq(:practice)
      expect(subject.connection).to be_a(Faraday::Connection)

      expect(subject.data.access_token).to eq(access_token)
      expect(subject.data.api_server).to eq(api_server)
      expect(subject.data.expires_in).to eq(expires_in)
      expect(subject.data.refresh_token).to eq(refresh_token)
      expect(subject.data.token_type).to eq(token_type)
    end
  end

  context '#refresh_token' do
  end

  context '#access_token' do
    subject { QuestradeApi::Authorization.new(data) }

    it 'returns value of #data.access_token' do
      expect(subject.access_token).to eq(access_token)
    end
  end

  context '#url' do
    subject { QuestradeApi::Authorization.new(data) }

    it 'returns value of #data.api_server' do
      expect(subject.url).to eq(api_server)
    end
  end

  context '#live?' do
    it 'returns true if live' do
      subject = QuestradeApi::Authorization.new(data, :live)
      expect(subject.live?).to be_truthy
    end

    it 'returns false if practice' do
      subject = QuestradeApi::Authorization.new(data)
      expect(subject.live?).to be_falsy
    end
  end
end
