# frozen_string_literal: true

class Ambassador
  ##
  # Raised when trying to expose an unsafe property
  class InvalidPropertyError < StandardError
    # @param property_name [String, Symbol]
    def initialize(property_name)
      super
      @property_name = property_name
    end

    # @return [String]
    def message
      "Cannot define a read-only property named #{@property_name}"
    end
  end
end
