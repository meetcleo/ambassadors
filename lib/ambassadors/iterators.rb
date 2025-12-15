# frozen_string_literal: true

module Ambassadors
  ##
  # Iteration strategies are used to allow an +AmbassadorCollection+ to define
  # how it should iterate over its enumerable. This might include
  # setting limits on how many records are loaded from a DB at a time, or
  # how to safely paginate records on a 3rd party API.
  module Iterators # :nodoc:
    require_relative "iteration_strategies/iteration_strategy"
    require_relative "iteration_strategies/each_strategy"
    require_relative "iteration_strategies/find_each_strategy"
    require_relative "iteration_strategies/iteration_strategy_factory"
  end
end
