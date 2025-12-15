# frozen_string_literal: true

class AmbassadorCollection
  module IterationStrategies
    ##
    # Strategy to use in +AmbassadorCollection+ when it's safe to
    # iterate over each item in the set.
    class EachStrategy < IterationStrategy
    end
  end
end
