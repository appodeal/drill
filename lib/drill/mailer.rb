# frozen_string_literal: true

require 'drill/params'
require 'drill/mail'

module Drill
  class Mailer
    attr_reader :action_name

    class << self
      private

      def method_missing(method, *args)
        super unless respond_to_missing?(method)

        new(method).public_send(method, *args)
      end

      def respond_to_missing?(method, include_all = false)
        public_instance_methods(false).include?(method) || super
      end
    end

    def initialize(action_name)
      @action_name = action_name
    end

    def mail(params = {})
      params = Params.new(params)
      params.vars = Hash(params.vars).merge(vars)

      template_name = params[:template_name] || action_name

      Mail.new(params.to_mandrill_message, template_name)
    end

    private

    def vars
      instance_variables.each.with_object({}) do |instance_variable, vars|
        name = instance_variable.to_s.sub('@')
        content = instance_variable_get(instance_variable)

        vars[name] = content
      end
    end
  end
end
