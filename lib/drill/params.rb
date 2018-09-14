# frozen_string_literal: true

module Drill
  Params = Struct.new(
    :from_name, :from_email, :reply_to, :cc, :to, :vars, :template_name,
    keyword_init: true
  ) do
    def merge_vars(other_vars)
      self.vars = Hash(vars).merge(other_vars)
    end

    def to_mandrill_message
      message = {}
      to_emails = Array(to).map { |email| { email: email } }
      cc_emails = Array(cc).map { |email| { email: email, type: 'cc' } }
      all_emails = to_emails + cc_emails
      mandrill_vars =
        Hash(vars).map { |k, v| { name: k.to_s.upcase, content: v } }

      unless all_emails.empty?
        message[:to] = all_emails
        unless mandrill_vars.empty?
          message[:merge_vars] = all_emails.each.with_object([]) do |email, arr|
            arr << { rcpt: email[:email], vars: mandrill_vars }
          end
        end
      end
      message[:from_name] = from_name if from_name
      message[:from_email] = from_email if from_email
      message[:headers] = { 'Reply-To' => reply_to } if reply_to

      message
    end
  end
end
