# frozen_string_literal: true

require 'drill/version'
require 'drill/mailer'

module Drill
  Configuration = Struct.new(:api_key)

  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration
  end

  def client
    @client ||= Mandrill::API.new(configuration.api_key)
  end
end
