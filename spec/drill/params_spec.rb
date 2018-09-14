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

  describe '#to_mandrill_message' do
    let(:params) do
      Drill::Params.new(
        from_name: 'John Doe',
        from_email: 'johndoe@email.com',
        reply_to: 'replyto@email.com',
        cc: 'cc@email.com',
        to: 'to@email.com',
        vars: {
          foo_bar: 'foo_bar',
          bar_foo: 'bar_foo'
        }
      )
    end

    it 'returns hash acceptable by Mandrill::API' do
      expect(params.to_mandrill_message)
        .to eq(
          to: [
            { email: 'to@email.com' },
            { email: 'cc@email.com', type: 'cc' }
          ],
          merge_vars: [
            {
              rcpt: 'to@email.com',
              vars: [
                { name: 'FOO_BAR', content: 'foo_bar' },
                { name: 'BAR_FOO', content: 'bar_foo' }
              ]
            },
            {
              rcpt: 'cc@email.com',
              vars: [
                { name: 'FOO_BAR', content: 'foo_bar' },
                { name: 'BAR_FOO', content: 'bar_foo' }
              ]
            }
          ],
          from_name: 'John Doe',
          from_email: 'johndoe@email.com',
          headers: { 'Reply-To' => 'replyto@email.com' }
        )
    end

    context 'when there are no params' do
      let(:params) { Drill::Params.new }

      it 'returns empty hash' do
        expect(params.to_mandrill_message).to eq({})
      end
    end

    context 'when `to` and `cc` attributes are arrays' do
      let(:params) do
        Drill::Params.new(
          to: %w[to1@email.com to2@email.com],
          cc: %w[cc1@email.com cc2@email.com]
        )
      end

      it 'returns correct `to` value' do
        expect(params.to_mandrill_message)
          .to eq(
            to: [
              { email: 'to1@email.com' },
              { email: 'to2@email.com' },
              { email: 'cc1@email.com', type: 'cc' },
              { email: 'cc2@email.com', type: 'cc' }
            ]
          )
      end
    end
  end
end
