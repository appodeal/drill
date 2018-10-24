# frozen_string_literal: true

require 'drill/version'
require 'drill/mailer'
require 'drill/delivery_worker'
require 'mandrill'

module Drill
  Configuration = Struct.new(
    :api_key, :delivery_method, :default_vars,
    keyword_init: true
  )

  module_function

  def configuration
    @configuration ||= Configuration.new(
      delivery_method: :default,
      default_vars: {}
    )
  end

  def configure
    yield configuration
  end

  def client
    @client ||= Mandrill::API.new(configuration.api_key)
  end
end
