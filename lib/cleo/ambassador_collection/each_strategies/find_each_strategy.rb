# frozen_string_literal: true

class AmbassadorCollection
  class EachStrategies
    ##
    # Strategy to use in +AmbassadorCollection+ when it's safer to paginate
    # over batches of the data.
    class FindEachStrategy
      def each(enumerable, &)
        enumerable.find_each(&)
      end
    end
  end
end
