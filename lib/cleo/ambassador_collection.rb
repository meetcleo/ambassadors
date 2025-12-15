# frozen_string_literal: true
# typed: false

##
# Handles a collection of +Ambassador+ objects
# @see Ambassador
class AmbassadorCollection
  ##
  # Raised when we are unable to determine which +Ambassador+ class to load
  class UresolvedAmbassadorError < StandardError; end

  require_relative "ambassador_collection/iteration_strategies/each_strategy"
  require_relative "ambassador_collection/iteration_strategies/find_each_strategy"

  include Enumerable

  ##
  # If a batching strategy is used, load this number of records per batch
  # @return [Integer]
  DEFAULT_BATCH_SIZE = 1_000

  def initialize(enumerable, ambassador_class: nil, batch_size: DEFAULT_BATCH_SIZE)
    @enumerable = enumerable
    @ambassador_class = ambassador_class
    @batch_size = batch_size
    @iteration_strategy = determine_iteration_strategy(enumerable:, batch_size:)
  end

  def each
    @iteration_strategy.to_enum unless block_given?
    @iteration_strategy.each do |item|
      yield(cast_to_ambassador(item))
    end
    # return enum_for(@iteration_strategies) unless block_given?
    #
    # @enumerable.public_send(@iteration_strategies) do
  end

  ##
  # The number of items in the current collection
  # @return [Integer]
  def length
    @enumerable.to_a.length
  end

  alias size length
  alias count length

  protected

  ##
  # Cast the given item with the most appropriate Ambassador class.
  # Will prioritise in the following order:
  #   - +#to_ambassador+ called on the item
  #   - +@ambassador_class+ if defined
  #   - Infer based on the class name (e.g. +User+ => +UserAmbassador+)
  # @return [Ambassador] Instance of an Ambassador class for this item
  # @raise [UresolvedAmbassadorError]
  def cast_to_ambassador(item)
    if item.respond_to?(:to_ambassador)
      item.to_ambassador
    elsif @ambassador_class
      @ambassador_class.new(item)
    else
      raise "Cannot infer ambassador for #{item}" unless item.class.name
      inferred_ambassador_class_name = "#{item.class.name}Ambassador"
      unless Module.const_defined?(inferred_ambassador_class_name)
        raise "Cannot infer ambassador for #{item}"
      end

      Module.const_get(inferred_ambassador_class_name)
    end
  end

  def determine_iteration_strategy(enumerable:, batch_size:)
    if defined?(ActiveRecord::Relation) && enumerable.is_a?(ActiveRecord::Relation)
      IterationStrategies::FindEachStrategy
    else
      IterationStrategies::EachStrategy
    end.new(enumerable: enumerable, batch_size: batch_size)
  end
end
