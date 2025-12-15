# frozen_string_literal: true

class AmbassadorCollection
  module IterationStrategies
    ##
    # Strategy to use in +AmbassadorCollection+ when it's safe to
    # iterate over each item in the set.
    class EachStrategy

      def initialize(enumerable:, **kwargs)
        @enumerable = enumerable
      end

      def each(&)
        @enumerable.each(&)
      end

      def to_enum
        enum_for(:each)
      end
    end
  end
end
