# frozen_string_literal: true

require 'drill/mail/base'

module Drill
  module Mail
    class Default < Base
      def deliver
        return if params.skip_delivery

        template_name = params.template_name

        Drill.client.messages.send_template(template_name, [], message_hash)
      end

      def deliver_later(wait: nil)
        return if params.skip_delivery

        template_name = params.template_name

        if wait
          worker.perform_in(wait.to_i, template_name, message_hash)
        else
          worker.perform_async(template_name, message_hash)
        end
      end

      private

      def worker
        Drill::DeliveryWorker
      end

      def message_hash
        message_hash = {}

        to_emails = Array(params.to).map do |email|
          { email: email }
        end
        cc_emails = Array(params.cc).map do |email|
          { email: email, type: 'cc' }
        end
        vars = Hash(params.vars).map do |name, content|
          { name: name.to_s.upcase, content: content }
        end

        all_emails = to_emails + cc_emails
        unless all_emails.empty?
          message_hash[:to] = all_emails

          unless vars.empty?
            message_hash[:merge_vars] =
              all_emails.each.with_object([]) do |email, arr|
                arr << { rcpt: email[:email], vars: vars }
              end
          end
        end
        message_hash[:from_name] = params.from_name if params.from_name
        message_hash[:from_email] = params.from_email if params.from_email
        if params.reply_to
          message_hash[:headers] = { 'Reply-To' => params.reply_to }
        end

        message_hash
      end
    end
  end
end
