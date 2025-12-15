# frozen_string_literal: true


module Ambassadors
  module IterationStrategies
    ##
    # Strategy to use in +AmbassadorCollection+ when it's safer to paginate
    # over batches of the data.
    class FindEachStrategy < IterationStrategy
      def initialize(batch_size:, **kwargs)
        super(**kwargs)
        @batch_size = batch_size
      end

      def each(&block)
        return enum_for(:each) unless block_given?

        @enumerable.find_each(batch_size: @batch_size, &block)
      end
    end
    private_constant :FindEachStrategy
  end
end
