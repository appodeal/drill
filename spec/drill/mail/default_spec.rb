# frozen_string_literal: true

RSpec.describe Drill::Mail::Default do
  let(:mail) { Drill::Mail::Default.new(params) }
  let(:params) do
    Drill::Params.new(
      template_name: :template_name,
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
  let(:client_double) do
    instance_double(Mandrill::API, messages: messages_double)
  end
  let(:messages_double) { instance_double(Mandrill::Messages) }

  before do
    allow(Drill).to receive(:client).and_return(client_double)
  end

  describe '#deliver' do
    it 'sends template with correct name and message' do
      expect(messages_double)
        .to receive(:send_template)
        .with(
          :template_name,
          [],
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

      mail.deliver
    end

    context 'when `to` and `cc` params are arrays' do
      let(:params) do
        Drill::Params.new(
          to: %w[to1@email.com to2@email.com],
          cc: %w[cc1@email.com cc2@email.com]
        )
      end

      it 'sends template with correct `to` value' do
        expect(messages_double)
          .to receive(:send_template)
          .with(
            nil,
            [],
            to: [
              { email: 'to1@email.com' },
              { email: 'to2@email.com' },
              { email: 'cc1@email.com', type: 'cc' },
              { email: 'cc2@email.com', type: 'cc' }
            ]
          )

        mail.deliver
      end
    end

    context 'when there are no params' do
      let(:params) { Drill::Params.new }

      # TODO: implement this
      xit 'handles error'
    end
  end
end
