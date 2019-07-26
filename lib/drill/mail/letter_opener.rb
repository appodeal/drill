# frozen_string_literal: true

require 'mail'
require 'letter_opener'
require 'drill/mail/base'

module Drill
  module Mail
    class LetterOpener < Base
      attr_reader :mail, :delivery_method

      def initialize(
        params,
        mail = ::Mail.new,
        delivery_method = ::LetterOpener::DeliveryMethod.new
      )
        super(params)

        @mail = mail
        @delivery_method = delivery_method
      end

      def deliver
        return if params.skip_delivery

        prepare_mail!

        delivery_method.deliver!(mail)
      end

      def deliver_later(wait: nil)
        deliver
      end

      private

      def prepare_mail!
        mail.to = Array(params.to) + Array(params.cc)
        mail.from = params.from_email
        mail.sender = params.from_name
        mail.reply_to = params.reply_to
        mail.content_type = 'text/html'
        mail.body = render_html
      end

      def render_html
        template_name = params.template_name
        merge_vars =
          params.vars.each.with_object([]) do |(name, content), arr|
            arr << { name: name.to_s.upcase, content: content }
          end

        Drill.client.templates.render(template_name, [], merge_vars)['html']
      end
    end
  end
end
