# frozen_string_literal: true

require 'mandrill'

RSpec.describe Drill::Mail do
  let(:mail) { Drill::Mail.new(params_double) }
  let(:params_double) do
    instance_double(
      Drill::Params,
      to_mandrill_message: :message,
      template_name: :template_name
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
    it 'sends message with template' do
      expect(messages_double)
        .to receive(:send_template)
        .with(:template_name, [], :message)

      mail.deliver
    end
  end
end
