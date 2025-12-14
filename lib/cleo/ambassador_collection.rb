# frozen_string_literal: true
# typed: false

##
# Handles a collection of +Ambassador+ objects
# @see Ambassador
class AmbassadorCollection
  require_relative "ambassador_collection/each_strategies/each_strategy"
  require_relative "ambassador_collection/each_strategies/find_each_strategy"

  include Enumerable

  def initialize(enumerable)
    @enumerable = enumerable
    @each_strategy = (enumerable.is_a?(ActiveRecord::Relation) ? EachStrategies::FindEach : EachStrategies::Each).new
    @ambassador_class = UserAmbassador
  end

  def each
    @each_strategy.each(@enumerable) do |item|
      yield(@ambassador_class.new(item))
    end
  end
end
