# frozen_string_literal: true

RSpec.describe Drill::Mailer do
  let(:mailer) do
    Class.new(Drill::Mailer) do
      def notify(foo, bar); end
    end
  end
  let(:args) { %i[foo bar] }

  it 'delegates action method from class to instance' do
    mailer_instance = instance_double(mailer)
    allow(mailer).to receive(:new).and_return(mailer_instance)
    args = %i[foo bar]

    expect(mailer_instance).to receive(:notify).with(*args)

    mailer.notify(*args)
  end

  it 'raises an error when there is no public method defined' do
    expect { mailer.foo }.to raise_error NoMethodError
  end

  describe '#mail' do
    let(:mailer) do
      Class.new(Drill::Mailer) do
        def notify(params = {})
          @foo = 'foo'

          mail(params)
        end
      end
    end

    it 'sets vars from instance variables' do
      mail = mailer.notify

      expect(mail.params.vars).to eq(foo: 'foo')
    end

    it 'sets action name as template name' do
      mail = mailer.notify

      expect(mail.params.template_name).to eq(:notify)
    end

    it 'ignores extra params' do
      expect { mailer.notify(foo: :foo, bar: :bar) }.not_to raise_error
    end

    context 'when template name is passed' do
      it 'overrides action name' do
        mail = mailer.notify(template_name: :template_name)

        expect(mail.params.template_name).to eq(:template_name)
      end
    end

    context 'when vars are passed' do
      it 'merges them with vars from instance variables' do
        mail = mailer.notify(vars: { bar: 'bar' })

        expect(mail.params.vars).to eq(foo: 'foo', bar: 'bar')
      end
    end
  end
end
