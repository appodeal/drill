module Drill
  class Base
    attr_reader :params

    def initialize(params)
      @params = params
    end
  end
end
