# frozen_string_literal: true

module Drill
  module Mail
    autoload :Default, 'drill/mail/default'
    autoload :LetterOpener, 'drill/mail/letter_opener'

    module_function

    def new(params)
      mail.new(params)
    end

    def mail
      case Drill.configuration.delivery_method
      when :letter_opener
        LetterOpener
      else
        Default
      end
    end
  end
end
