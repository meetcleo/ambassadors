module Ambassadors

module IterationStrategies
    class IterationStrategyFactory

      def self.build(...)
        new(...).iteration_strategy
      end

      def initialize(enumerable:, batch_size:)
        @enumerable = enumerable
        @batch_size = batch_size
      end

      ##
      # @return [IterationStrategy]
      def iteration_strategy
        if defined?(ActiveRecord::Relation) && @enumerable.is_a?(ActiveRecord::Relation)
          FindEachStrategy
        else
          EachStrategy
        end.new(enumerable: @enumerable, batch_size: @batch_size)
      end
    end
  end
end
