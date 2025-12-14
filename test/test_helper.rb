# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cleo_ambassador"

require "minitest/autorun"
require "mocha/minitest"
module Minitest
  class Test
    def self.test(name, &)
      define_method("test_#{name}", &)
    end
  end
end
