# typed: false
# frozen_string_literal: true

require "test_helper"

require "ambassadors"

class AmbassadorTest < Minitest::Test
  class TestFooAmbassador < Ambassador
    expose :foo
    expose :fizz, :buzz

    def bar
      "Bar: #{entity.bar}"
    end
  end

  test ".expose defines a property on the enveloped entity that can be accessed" do
    entity = stub("TestFoo", foo: "foo-value")

    assert_equal "foo-value", TestFooAmbassador.new(entity).foo
  end

  test ".expose accepts multiple property names" do
    entity = stub("TestFoo", fizz: "fizz-value", buzz: "buzz-value")

    assert_equal "fizz-value", TestFooAmbassador.new(entity).fizz
    assert_equal "buzz-value", TestFooAmbassador.new(entity).buzz
  end

  test ".expose freezes unfrozen values" do
    foo_value = +"foo-value"
    entity = stub("TestFoo", foo: foo_value)

    refute_predicate foo_value, :frozen?

    return_value = TestFooAmbassador.new(entity).foo

    assert_predicate return_value, :frozen?
  end

  test ".expose leaves frozen values as frozen" do
    foo_value = -"foo-value"
    entity = stub("TestFoo", foo: foo_value)

    assert_predicate foo_value, :frozen?

    return_value = TestFooAmbassador.new(entity).foo

    assert_predicate return_value, :frozen?
  end

  test ".expose methods will raise a NoMethodError if object does not respond to it" do
    entity = Object.new
    assert_raises(NoMethodError) { TestFooAmbassador.new(entity).foo }
  end

  test ".expose methods will call locally defined methods" do
    bar_value = "bar-value"
    entity = stub("TestFoo", bar: bar_value)

    return_value = TestFooAmbassador.new(entity).bar

    assert_equal "Bar: bar-value", return_value
  end

  # Assume that bang methods have side-effects and are not safe to forward
  test ".expose methods will raise a InvalidPropertyError if method name is a bang" do
    assert_raises(Ambassadors::InvalidPropertyError) do
      Class.new(Ambassador) do
        expose :method_with_bang!
      end
    end
  end

  test ".expose methods will raise a InvalidPropertyError if method name is a setter" do
    assert_raises(Ambassadors::InvalidPropertyError) do
      Class.new(Ambassador) do
        expose :method_is_setter=
      end
    end
  end

  test "#inspect includes the class name" do
    entity = stub("TestFoo", foo: "foo-value", fizz: "fizz-value", buzz: "buzz-value")
    ambassador = TestFooAmbassador.new(entity)

    assert_includes ambassador.inspect, "TestFooAmbassador"
  end

  test "#inspect includes the properties and their values" do
    entity = stub("TestFoo", foo: "foo-value", fizz: "fizz-value", buzz: 1)

    ambassador = TestFooAmbassador.new(entity)

    assert_includes ambassador.inspect, 'foo="foo-value"'
    assert_includes ambassador.inspect, 'fizz="fizz-value"'
    assert_includes ambassador.inspect, "buzz=1"
  end

  test "#inspect excludes public methods that are not exposed" do
    entity = stub("TestFoo", foo: "foo-value", fizz: "fizz-value", buzz: "buzz-value", bar: "bar-value")

    ambassador = TestFooAmbassador.new(entity)

    refute_includes ambassador.inspect, "bar: 'bar-value'"
  end

  test "#== returns true if the same entitiy is represented" do
    entity = stub("TestFoo", foo: "foo-value", fizz: "fizz-value", buzz: "buzz-value", bar: "bar-value")

    ambassador_a = TestFooAmbassador.new(entity)
    ambassador_b = TestFooAmbassador.new(entity)

    assert_equal ambassador_a, ambassador_b
  end
end
