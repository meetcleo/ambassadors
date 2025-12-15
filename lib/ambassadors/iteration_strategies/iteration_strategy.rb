# frozen_string_literal: true

module Ambassadors
  module IterationStrategies
    class IterationStrategy # :nodoc: all
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
