# frozen_string_literal: true

class AmbassadorCollection
  module IterationStrategies
    ##
    # Strategy to use in +AmbassadorCollection+ when it's safer to paginate
    # over batches of the data.
    class FindEachStrategy < EachStrategy
      def initialize(batch_size:, **kwargs)
        super(**kwargs)
        @batch_size = batch_size
      end

      def each(&)
        @enumerable.find_each(batch_size: @batch_size, &)
      end

      def to_enum
        enum_for(:each, batch_size: @batch_size)
      end
    end
  end
end
