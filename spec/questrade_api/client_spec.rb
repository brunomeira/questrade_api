require 'spec_helper'

require 'questrade_api/client'

describe QuestradeApi::Client do
  let(:refresh_token) { 'XXXXX' }
  let(:api_server) { 'http://test.com' }
  let(:access_token) { 'ABCDEF' }

  context '#initialize' do
    it 'refreshes token if refresh_token is present, and api_server and access_token are not'  do
      expect_any_instance_of(QuestradeApi::Client).to receive(:refresh_token).once
      QuestradeApi::Client.new(refresh_token: refresh_token)
    end

    it 'does not refreshes token if refresh_token is present, and api_server and/or access_token are'  do
      expect_any_instance_of(QuestradeApi::Client).to receive(:refresh_token).never
      QuestradeApi::Client.new(refresh_token: refresh_token,
                               api_server: api_server)

      QuestradeApi::Client.new(refresh_token: refresh_token,
                               access_token: access_token)

      QuestradeApi::Client.new(refresh_token: refresh_token,
                               api_server: api_server,
                               access_token: access_token)
    end
  end

  context '#refresh_token' do
    it 'calls authorization refresh token' do
      client = QuestradeApi::Client.new(refresh_token: refresh_token, access_token: access_token)
      expect(client.authorization).to receive(:refresh_token).once

      client.refresh_token
    end
  end
end
