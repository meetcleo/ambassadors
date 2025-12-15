# frozen_string_literal: true

module Ambassadors
  ##
  # Validates that exposed property names are safe
  class PropertyNameChecker
    # @return [Symbol]
    attr_reader :property_name

    # @param property_name [Symbol]
    def initialize(property_name)
      @property_name = property_name
    end

    # @raise [InvalidPropertyError] if method is not something we want to expose
    # @return [void]
    def check!
      raise Ambassadors::InvalidPropertyError, property_name if property_name_is_bang?
      raise Ambassadors::InvalidPropertyError, property_name if property_name_is_setter?
    end

    private

    def property_name_is_bang?
      property_name.to_s.end_with?("!")
    end

    def property_name_is_setter?
      property_name.to_s.end_with?("=")
    end
  end

  private_constant :PropertyNameChecker
end
