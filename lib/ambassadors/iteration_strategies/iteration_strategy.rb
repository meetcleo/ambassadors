module Ambassadors

  module IterationStrategies
    class IterationStrategy

      def initialize(enumerable:, **kwargs)
        @enumerable = enumerable
      end

      def each(&block)
        return enum_for(:each) unless block_given?

        @enumerable.each(&block)
      end
    end
  end

end
