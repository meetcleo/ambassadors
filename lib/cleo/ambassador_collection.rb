# frozen_string_literal: true
# typed: false

##
# Handles a collection of +Ambassador+ objects
# @see Ambassador
class AmbassadorCollection
  require_relative "ambassador_collection/iteration_strategies"
  require "ambassadors/ambassador_factory"

  include Enumerable

  ##
  # If a batching strategy is used, load this number of records per batch
  # @return [Integer]
  DEFAULT_BATCH_SIZE = 1_000

  def initialize(enumerable, ambassador_class: nil, batch_size: DEFAULT_BATCH_SIZE)
    @enumerable = enumerable
    @iteration_strategy = IterationStrategies::IterationStrategyFactory.build(enumerable:, batch_size:)
    @ambassador_factory = Ambassadors::AmbassadorFactory.new(default_ambassador_class: ambassador_class)
  end

  def each
    return enum_for(:each) unless block_given?

    @iteration_strategy.to_enum.each do |item|
      yield(@ambassador_factory.cast(item))
    end
  end

  ##
  # The number of items in the current collection
  # @return [Integer]
  def length
    @enumerable.to_a.length
  end

  alias size length
  alias count length
end
