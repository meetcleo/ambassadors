# frozen_string_literal: true

class AmbassadorCollection
  module IterationStrategies # :nodoc:
    require_relative "iteration_strategies/iteration_strategy"
    require_relative "iteration_strategies/each_strategy"
    require_relative "iteration_strategies/find_each_strategy"
    require_relative "iteration_strategies/iteration_strategy_factory"
  end
end
