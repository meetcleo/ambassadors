# frozen_string_literal: true

require "test_helper"

class AmbassadorCollectionTest < Minitest::Test
  test "#each iterates over the items in enumerable" do
    entities = [
      build(:entity, id: 1),
      build(:entity, id: 2),
      build(:entity, id: 3)
    ]
    ambassador_class = Class.new(Ambassador) do
      expose :id
    end

    collection = AmbassadorCollection.new(
      entities,
      ambassador_class: ambassador_class
    )

    assert_respond_to collection, :each

    returned_ids = collection.map(&:id)

    assert_equal [1, 2, 3], returned_ids
  end

  test "#each returns an Ambassador object for each item in enumerable" do
    entities = [
      build(:entity, id: 1),
      build(:entity, id: 2),
      build(:entity, id: 3)
    ]
    ambassador_class = Class.new(Ambassador) do
      expose :id
    end

    collection = AmbassadorCollection.new(
      entities,
      ambassador_class: ambassador_class
    )

    returned_classes = collection.map(&:class)

    assert_equal(3.times.map { ambassador_class }, returned_classes)
  end

  test "#each batches ActiveRecord::Relation according to batch_size" do
    with_test_table(:test_entities, name: { type: :string, null: false }) do
      model = Class.new(ActiveRecord::Base) do
        self.table_name = "test_entities"
      end

      6.times do |i|
        model.create!(name: "Entity #{i + 1}")
      end

      enumerable = model.order(:id)

      ambassador_class = Class.new(Ambassador) do
        expose :id, :name
      end

      collection = AmbassadorCollection.new(
        enumerable,
        ambassador_class: ambassador_class,
        batch_size: 5
      )

      rows_per_query = []
      callback = lambda do |_name, _start, _finish, _id, payload|
        rows_per_query.push(payload[:row_count])
      end

      ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
        collection.each { |_ambassador| nil }
      end

      assert_equal 5, rows_per_query.first
      assert_equal 1, rows_per_query.second
    end
  end

  test "#each defaults batch_size to 1000 for ActiveRecord::Relation objects" do
    with_test_table(:test_entities, name: { type: :string, null: false }) do
      model = Class.new(ActiveRecord::Base) do
        self.table_name = "test_entities"
      end
      6.times do |i|
        model.create!(name: "Entity #{i + 1}")
      end
      enumerable = model.order(:id)
      ambassador_class = Class.new(Ambassador) do
        expose :id, :name
      end

      collection = AmbassadorCollection.new(
        enumerable,
        ambassador_class: ambassador_class
      )

      sql_event_payloads = []
      callback = lambda do |_name, _start, _finish, _id, payload|
        sql_event_payloads.push(payload)
      end

      ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
        collection.each { |_ambassador| nil }
      end

      assert_equal 1, sql_event_payloads.length,
                   "Expected only 1 SQL query but there were #{sql_event_payloads.length}"
      sql_event_payload = sql_event_payloads.first
      # This assertion checks that the limit value is passed in as 1000.
      # This might break in future versions of ActiveRecord
      assert_equal 1000, sql_event_payload[:binds].find { |b| b.name == "LIMIT" }.value,
                   "Expected the SQL query bind to eql 1000 but was #{sql_event_payload[:binds]}"
    end
  end

  test "#each returns an enumerator when no block is given" do
    collection = AmbassadorCollection.new([])

    assert_instance_of Enumerator, collection.each
  end

  test "#each returns an enumerator when no block is given (ActiveRecord::Relation)" do
    with_test_table(:test_entities, name: { type: :string, null: false }) do
      model = Class.new(ActiveRecord::Base) do
        self.table_name = "test_entities"
      end
      6.times do |i|
        model.create!(name: "Entity #{i + 1}")
      end
      enumerable = model.order(:id)
      ambassador_class = Class.new(Ambassador) do
        expose :id, :name
      end

      collection = AmbassadorCollection.new(
        enumerable,
        ambassador_class: ambassador_class
      )

      assert_instance_of Enumerator, collection.each
    end
  end

  test "#each casts item as Ambassador when being iterated manually" do
    enumerable = [build(:entity, id: 1)]
    ambassador_class = Class.new(Ambassador) do
      expose :id
    end
    collection = AmbassadorCollection.new(enumerable, ambassador_class: ambassador_class)

    enumerator = collection.each

    assert_instance_of ambassador_class, enumerator.next
  end

  test "#length returns the number of items in the collection" do
    entities = [
      build(:entity, id: 1),
      build(:entity, id: 2),
      build(:entity, id: 3)
    ]
    ambassador_class = Class.new(Ambassador) do
      expose :id
    end

    collection = AmbassadorCollection.new(
      entities,
      ambassador_class: ambassador_class
    )

    assert_equal(3, collection.length)
  end

  test "#size (alias) returns the number of items in the collection" do
    entities = [
      build(:entity, id: 1),
      build(:entity, id: 2),
      build(:entity, id: 3)
    ]
    ambassador_class = Class.new(Ambassador) do
      expose :id
    end

    collection = AmbassadorCollection.new(
      entities,
      ambassador_class: ambassador_class
    )

    assert_equal(3, collection.size)
  end

  test "#count (alias) returns the number of items in the collection" do
    entities = [
      build(:entity, id: 1),
      build(:entity, id: 2),
      build(:entity, id: 3)
    ]
    ambassador_class = Class.new(Ambassador) do
      expose :id
    end

    collection = AmbassadorCollection.new(
      entities,
      ambassador_class: ambassador_class
    )

    assert_equal(3, collection.count)
  end

  private

  def build(factory_name, *_traits, **attributes)
    stub(factory_name.to_s, attributes)
  end
end
