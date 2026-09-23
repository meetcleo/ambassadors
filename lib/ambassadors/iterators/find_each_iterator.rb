# frozen_string_literal: true

module Ambassadors
  module Iterators
    ##
    # Strategy to use in +AmbassadorCollection+ when it's safer to paginate
    # over batches of the data.
    class FindEachIterator < Iterator
      def initialize(batch_size:, cursor: nil, order: nil, **)
        super(**)
        @batch_size = batch_size
        @cursor = cursor || @enumerable.primary_key
        @order = order || :asc
      end

      def each(&)
        return enum_for(:each) unless block_given?

        @enumerable.find_each(batch_size: @batch_size, cursor: @cursor, order: @order, &)
      end
    end
  end
end
