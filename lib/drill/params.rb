# frozen_string_literal: true

module Drill
  Params = Struct.new(
    :from_name,
    :from_email,
    :reply_to,
    :cc,
    :to,
    :vars,
    :template_name,
    :skip_delivery,
    keyword_init: true
  ) do
    def merge_vars(other_vars)
      self.vars = Hash(vars).merge(other_vars)
    end
  end
end
