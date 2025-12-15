# frozen_string_literal: true

module Ambassadors
  module Iterators
    class IteratorFactory # :nodoc:
      def self.build(...)
        new(...).iteration_strategy
      end

      def initialize(enumerable:, batch_size:)
        @enumerable = enumerable
        @batch_size = batch_size
      end

      ##
      # @return [Iterator]
      def iteration_strategy
        if defined?(ActiveRecord::Relation) && @enumerable.is_a?(ActiveRecord::Relation)
          FindEachIterator
        else
          EachIterator
        end.new(enumerable: @enumerable, batch_size: @batch_size)
      end
    end
  end
end
