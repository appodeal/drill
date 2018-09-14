# frozen_string_literal: true

module Drill
  class Mail
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def deliver
      message = params.to_mandrill_message
      template_name = params.template_name

      Drill.client.messages.send_template(template_name, [], message)
    end
  end
end
