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
      params[:template_name] ||= action_name

      params = Params.new(permitted_params(params))
      params.merge_vars(vars_from_instance_variables)
      params.merge_vars(Drill.configuration.default_vars)

      Mail.new(params)
    end

    private

    def permitted_params(params)
      params.slice(*Params.members)
    end

    def vars_from_instance_variables
      permitted_instance_variables
        .each.with_object({}) do |instance_variable, vars|
          name = instance_variable.to_s.sub('@', '').to_sym
          content = instance_variable_get(instance_variable)

          vars[name] = content
        end
    end

    def permitted_instance_variables
      instance_variables - %i[@action_name]
    end
  end
end
