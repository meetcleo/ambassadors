module Ambassadors
  class Error < StandardError; end

  ##
  # Raised when we are unable to determine which +Ambassador+ class to load
  class UresolvedAmbassadorError < Error; end

  ##
  # Raised when trying to expose an unsafe property
  class InvalidPropertyError < Error
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
