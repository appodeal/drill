# frozen_string_literal: true

require 'mandrill'

RSpec.describe Drill do
  it 'has a version number' do
    expect(Drill::VERSION).not_to be nil
  end

  describe 'module functions' do
    before do
      Drill.configure do |config|
        config.api_key = :api_key
      end
    end

    describe '::configuration' do
      it 'returns correct configuration' do
        expect(Drill.configuration.api_key).to eq(:api_key)
      end

      it 'sets default configuration' do
        aggregate_failures do
          expect(Drill.configuration.delivery_method).to eq(:default)
          expect(Drill.configuration.default_vars).to eq({})
        end
      end
    end

    describe '::client' do
      it 'returns mandrill api client' do
        expect(Mandrill::API).to receive(:new).with(:api_key).and_return(:api)

        Drill.client
      end
    end
  end
end

