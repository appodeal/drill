require 'sidekiq'

module Drill
  class DeliveryWorker
    include Sidekiq::Worker
    sidekiq_options queue: :drill_mailer

    def perform(template_name, message_hash)
      Drill.client.messages.send_template(template_name, [], message_hash)
    end
  end
end
