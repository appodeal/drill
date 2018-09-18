# frozen_string_literal: true

RSpec.describe Drill::Params do
  describe '#merge_vars' do
    let(:params) { Drill::Params.new(vars: { foo: :foo }) }
    let(:other_vars) { Hash(bar: :bar) }

    it 'merges other vars to vars' do
      params.merge_vars(other_vars)

      expect(params.vars).to eq(foo: :foo, bar: :bar)
    end

    context 'when params have no vars' do
      let(:params) { Drill::Params.new }

      it 'sets other vars' do
        params.merge_vars(other_vars)

        expect(params.vars).to eq(bar: :bar)
      end
    end
  end
end
