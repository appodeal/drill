# frozen_string_literal: true

RSpec.describe Drill::Mail::LetterOpener do
  let(:mail) do
    Drill::Mail::LetterOpener.new(params, mail_double, delivery_method_double)
  end
  let(:params) do
    Drill::Params.new(
      template_name: :template_name,
      from_name: 'John Doe',
      from_email: 'johndoe@email.com',
      reply_to: 'replyto@email.com',
      cc: 'cc@email.com',
      to: 'to@email.com',
      skip_delivery: skip_delivery,
      vars: {
        foo_bar: 'foo_bar',
        bar_foo: 'bar_foo'
      }
    )
  end
  let(:skip_delivery) { false }
  let(:mail_double) { Mail.new }
  let(:delivery_method_double) do
    instance_double(LetterOpener::DeliveryMethod, deliver!: true)
  end
  let(:client_double) do
    instance_double(Mandrill::API, templates: templates_double)
  end
  let(:templates_double) do
    instance_double(Mandrill::Templates, render: { 'html' => :html })
  end

  before do
    allow(Drill).to receive(:client).and_return(client_double)
  end

  describe '#deliver' do
    it 'prepares mail from params' do
      aggregate_failures do
        expect(mail_double).to receive(:to=).with(%w[to@email.com cc@email.com])
        expect(mail_double).to receive(:from=).with('johndoe@email.com')
        expect(mail_double).to receive(:sender=).with('John Doe')
        expect(mail_double).to receive(:reply_to=).with('replyto@email.com')
        expect(mail_double).to receive(:content_type=).with('text/html')
        expect(mail_double).to receive(:body=).with(:html)
      end

      mail.deliver
    end

    it 'delivers mail through delivery method' do
      expect(delivery_method_double).to receive(:deliver!).with(mail_double)

      mail.deliver
    end

    it 'renders html with correct merge vars' do
      expect(templates_double)
        .to receive(:render)
        .with(
          :template_name,
          [],
          [
            { name: 'FOO_BAR', content: 'foo_bar' },
            { name: 'BAR_FOO', content: 'bar_foo' }
          ]
        )

      mail.deliver
    end

    context 'when `to` and `cc` params are arrays' do
      let(:params) do
        Drill::Params.new(
          vars: {},
          to: %w[to1@email.com to2@email.com],
          cc: %w[cc1@email.com cc2@email.com]
        )
      end

      it 'sets correct `to` value on mail object' do
        expect(mail_double)
          .to receive(:to=)
          .with(%w[to1@email.com to2@email.com cc1@email.com cc2@email.com])

        mail.deliver
      end
    end

    context 'when there are no params' do
      let(:params) { Drill::Params.new }

      # TODO: implement this
      xit 'handles error'
    end

    describe '#deliver_later' do
      context "when 'skip_delivery' is true" do
        let(:skip_delivery) { true }

        it "doesn't call " do
          expect(delivery_method_double).not_to receive(:deliver!)

          mail.deliver_later
        end
      end

      context 'when `wait` param is not present' do
        it 'calls perform_async on worker' do
          expect(mail).to receive(:deliver).and_call_original
          expect(delivery_method_double).to receive(:deliver!)
          mail.deliver_later
        end
      end

      context 'when `wait` param is present' do
        it 'calls perform_in on worker' do
          expect(mail).to receive(:deliver).and_call_original
          expect(delivery_method_double).to receive(:deliver!)
          mail.deliver_later(wait: 10)
        end
      end
    end
  end
end
