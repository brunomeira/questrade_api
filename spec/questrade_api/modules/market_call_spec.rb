require 'spec_helper'

require 'questrade_api/modules/market_call'

describe QuestradeApi::MarketCall do
  class DummyClass
    attr_accessor :authorization

    def initialize(authorization)
      @authorization = authorization
    end
  end

  let(:authorization) do
    OpenStruct.new(access_token: '123', url: 'test')
  end

  subject { DummyClass.new(authorization).extend(QuestradeApi::MarketCall) }

  context '.markets' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Market).to receive(:fetch).and_return([])
      expect(subject.markets).to eq([])
    end
  end

  context '.symbols' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Symbol).to receive(:fetch).and_return([])
      expect(subject.symbols('')).to eq([])
    end
  end

  context '.symbol' do
    it 'calls proper endpoint' do
      expect_any_instance_of(QuestradeApi::REST::Symbol).to receive(:fetch).and_return([])
      expect(subject.symbol('1')).to be_a(QuestradeApi::REST::Symbol)
    end
  end

  context '.search_symbols' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Symbol).to receive(:search).and_return([])
      expect(subject.search_symbols('')).to eq([])
    end
  end

  context '.quotes' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Quote).to receive(:fetch).and_return([])
      expect(subject.quotes([123])).to eq([])
    end
  end

  context '.quote' do
    it 'calls proper endpoint' do
      expect_any_instance_of(QuestradeApi::REST::Quote).to receive(:fetch).and_return([])
      expect(subject.quote(1)).to be_a(QuestradeApi::REST::Quote)
    end
  end

  context '.candles' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Candle).to receive(:fetch).and_return([])
      expect(subject.candles('', '12')).to eq([])
    end
  end

  context '.symbol_options' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Market).to receive(:fetch).and_return([])
      expect(subject.markets).to eq([])
    end
  end
end
