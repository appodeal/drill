# frozen_string_literal: true

RSpec.describe Drill::Mail do
  let(:mail_double) { class_double(Drill::Mail::Default) }

  describe '::new' do
    it 'delegates ::new to ::mail' do
      params = :params

      allow(Drill::Mail).to receive(:mail).and_return(mail_double)
      expect(mail_double).to receive(:new).with(params)

      Drill::Mail.new(params)
    end
  end

  describe '::mail' do
    it 'returns LetterOpener if delivery method is set' do
      allow(Drill.configuration)
        .to receive(:delivery_method)
        .and_return(:letter_opener)

      expect(Drill::Mail.mail).to eq(Drill::Mail::LetterOpener)
    end

    it 'returns Default otherwise' do
      expect(Drill::Mail.mail).to eq(Drill::Mail::Default)
    end
  end
end
