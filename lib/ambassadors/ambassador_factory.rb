# frozen_string_literal: true

module Ambassadors
  class AmbassadorFactory # :nodoc:
    def initialize(default_ambassador_class: nil)
      @default_ambassador_class = default_ambassador_class
    end

    ##
    # Cast the given entity with the most appropriate Ambassador class.
    # Will prioritise in the following order:
    #   - +#to_ambassador+ called on the entity
    #   - +@ambassador_class+ if defined
    #   - Infer based on the class name (e.g. +User+ => +UserAmbassador+)
    # @return [Ambassador] Instance of an Ambassador class for this entity
    # @raise [UresolvedAmbassadorError]
    def cast(entity)
      return entity.to_ambassador if entity.respond_to?(:to_ambassador)

      return @default_ambassador_class.new(entity) if @default_ambassador_class

      raise UresolvedAmbassadorError, "Cannot infer ambassador for #{entity}" unless entity.class.name

      inferred_ambassador_class_for_entity(entity)
    end

    protected

    def inferred_ambassador_class_for_entity(entity)
      inferred_ambassador_class_name = "#{entity.class.name}Ambassador"

      unless Module.const_defined?(inferred_ambassador_class_name)
        raise UresolvedAmbassadorError, "Cannot infer ambassador for #{entity}"
      end

      Module.const_get(inferred_ambassador_class_name)
    end
  end
end
