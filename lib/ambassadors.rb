# frozen_string_literal: true

##
# Root module for Ambassadors behaviour.
# @note That two of the public classes defined in this module are actually
# cast to the top-level-namespace. This is purely for ergonomics.
# @see README.md for more information.
module Ambassadors
  require_relative "ambassadors/version"
  require_relative "ambassadors/ambassador"
  require_relative "ambassadors/ambassador_collection"
end
