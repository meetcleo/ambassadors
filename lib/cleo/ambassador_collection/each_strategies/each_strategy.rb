# frozen_string_literal: true

class AmbassadorCollection
  class EachStrategies
    ##
    # Strategy to use in +AmbassadorCollection+ when it's safe to
    # iterate over each item in the set.
    class EachStrategy
      def each(enumerable, &)
        enumerable.each(&)
      end
    end
  end
end
