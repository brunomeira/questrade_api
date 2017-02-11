require 'spec_helper'

require 'questrade_api/modules/account_call'

describe QuestradeApi::AccountCall do
  class DummyClass
    attr_accessor :authorization

    def initialize(authorization)
      @authorization = authorization
    end
  end

  let(:authorization) do
    OpenStruct.new(access_token: '123', url: 'test')
  end

  subject { DummyClass.new(authorization).extend(QuestradeApi::AccountCall) }

  context '.time' do
    it 'calls proper endpoint' do
      time = DateTime.now
      expect_any_instance_of(QuestradeApi::REST::Time).to receive(:fetch).and_return(time)

      expect(subject.time).to be(time)
    end
  end

  context '.accounts' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Account).to receive(:fetch).and_return([])
      expect(subject.accounts).to eq([])
    end
  end

  context '.positions' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Position).to receive(:fetch).and_return([])
      expect(subject.positions('1')).to eq([])
    end
  end

  context '.balances' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Balance).to receive(:fetch).and_return([])
      expect(subject.balances('1')).to eq([])
    end
  end

  context '.executions' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Execution).to receive(:fetch).and_return([])
      expect(subject.executions('1')).to eq([])
    end
  end

  context '.activities' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Activity).to receive(:fetch).and_return([])
      expect(subject.activities('1')).to eq([])
    end
  end

  context '.orders' do
    it 'calls proper endpoint' do
      expect(QuestradeApi::REST::Order).to receive(:fetch).and_return([])
      expect(subject.orders('1')).to eq([])
    end
  end
end
