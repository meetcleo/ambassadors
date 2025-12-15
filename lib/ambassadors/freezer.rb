# frozen_string_literal: true

module Ambassadors
  ##
  # Ensures any value returned from the entity is deeply frozen.
  # @abstract
  # @private
  class Freezer
    # @return [Object] the frozen value
    attr_reader :value

    # @param value [Object] the object to freeze
    def initialize(value)
      @value = value.frozen? ? value : value.dup.freeze
      freeze
    end
  end

  private_constant :Freezer
end
