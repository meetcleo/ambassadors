# frozen_string_literal: true

module Ambassadors
  module Iterators
    ##
    # Base class for custom iteration strategies.
    # Pass in the enumerable collection to iterate. Subclasses should define a
    # custom implementation of +#each+.
    #
    class Iterator
      ##
      # @param enumerable [Enumerable<Object>]
      def initialize(enumerable:, **_kwargs)
        @enumerable = enumerable
      end

      def each(&)
        return enum_for(:each) unless block_given?

        @enumerable.each(&)
      end
    end
  end
end
