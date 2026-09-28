# frozen_string_literal: true

module Ambassadors
  ##
  # Read-only wrapper around a domain entity.
  #
  # An Ambassador forms a stable, immutable interface that exposes selected
  # attributes of an entity to the outside world. Domain interface methods
  # return Ambassadors instead of the underlying entities, so internal models
  # are protected from direct access and can evolve safely.
  #
  # @note Although this class is defined under the {Ambassadors} namespace,
  # it defines the top-level constant {::Ambassador} for ergonomics.
  #
  # @example Defining a user ambassador
  #   class UserAmbassador < Ambassador
  #     expose :id, :email, :created_at
  #   end
  #
  #   user = User.find(...)
  #   ambassador = UserAmbassador.new(user)
  #   ambassador.email # => "user@example.com" (frozen)
  #   ambassador.payment_cards # => NoMethodError
  class ::Ambassador
    require "ambassadors/freezer"
    require "ambassadors/property_name_checker"

    class << self
      # Declares one or more methods that should be publicly exposed as read-only properties
      # Values returned from these methods are frozen.
      #
      # @param properties [Array<Symbol>] list of method names to expose
      # @return [void]
      #
      # @example
      #   class CardAmbassador < Ambassador
      #     expose :id, :email
      #   end
      def expose(*properties)
        properties = properties.map(&:to_sym)
        # Remove any methods that are already defined from the set of properties
        (properties - instance_methods).each do |property_name|
          check_property_name_is_exposable!(property_name)
          exposed_property_names.add(property_name)

          define_method(:"#{property_name}") do
            Freezer.new(entity.public_send(property_name)).value
          end
        end
      end

      private :instance_eval, :instance_exec

      private

      # @return [Set<Symbol>] the set of all exposed property names
      def exposed_property_names
        @exposed_property_names ||= Set.new
      end

      # @param property_name [Symbol]
      # @raise [InvalidPropertyError]
      # @return [void]
      def check_property_name_is_exposable!(property_name)
        PropertyNameChecker.new(property_name).check!
      end
    end

    # @param entity [Object] the internal domain object being wrapped
    def initialize(entity)
      @__entity__ = entity
      freeze
    end

    # @return [Object] the wrapped domain entity
    def entity
      @__entity__
    end

    def ==(other)
      other.respond_to?(:entity) && entity == other.entity
    end

    # String representation showing exposed fields and their values.
    #
    # @return [String]
    def inspect
      "<#{self.class.name} #{exposed_properties.map { |k, v| "#{k}=#{v.inspect}" }.join(", ").strip}>"
    end

    ##
    # Returns this Ambassador. (Used for polymorphic consistency)
    # @return [Ambassador]
    def to_ambassador
      self
    end

    private

    def exposed_properties
      hash = {}
      self.class.send(:exposed_property_names).each do |name|
        hash[name] = public_send(name)
      end
      hash
    end
  end
end
