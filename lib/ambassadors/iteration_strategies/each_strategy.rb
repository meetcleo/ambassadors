# frozen_string_literal: true

module Ambassadors
  module Iterators
    ##
    # Strategy to use in +AmbassadorCollection+ when it's safe to
    # iterate over each item in the set.
    class EachStrategy < IterationStrategy
    end
    private_constant :EachStrategy
  end
end
