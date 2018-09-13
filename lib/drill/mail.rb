# frozen_string_literal: true

module Drill
  class Mail
    attr_reader :message, :template_name

    def initialize(message, template_name)
      @message = message
      @template_name = template_name
    end

    def deliver
      Drill.client.messages.send_template(template_name, [], message)
    end
  end
end
