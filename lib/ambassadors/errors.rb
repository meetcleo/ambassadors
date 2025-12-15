module Ambassadors
  class Error < StandardError; end

  ##
  # Raised when we are unable to determine which +Ambassador+ class to load
  class UresolvedAmbassadorError < Error; end
end
