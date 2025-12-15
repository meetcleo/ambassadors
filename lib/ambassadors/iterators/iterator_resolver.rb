# frozen_string_literal: true

module Ambassadors
  module Iterators
    class IteratorResolver # :nodoc:
      def self.resolve(...)
        new(...).iterator_class
      end

      def initialize(enumerable:)
        @enumerable = enumerable
      end

      ##
      # @return [Iterator]
      def iterator_class
        if defined?(ActiveRecord::Relation) && @enumerable.is_a?(ActiveRecord::Relation)
          FindEachIterator
        else
          EachIterator
        end
      end
    end
  end
end
