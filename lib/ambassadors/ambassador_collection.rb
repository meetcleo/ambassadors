# frozen_string_literal: true
# typed: false

module Ambassadors
  ##
  # Collection wrapper for objects that can be represented as {Ambassadors::Ambassador}
  # instances.
  #
  # @note Although this class is defined under the {Ambassadors} namespace,
  # it reopens the top-level constant {::AmbassadorCollection}.
  #
  # @note The +#each+ method will use batch loading behind the scenes when
  # enumerable is an ActiveRecord::Relation. This is to protect the database
  # against loading enormous queries.
  #
  # @example Wrap an Array of models
  #   collection = AmbassadorCollection.new(users, ambassador_class: UserAmbassador)
  #   collection.each do |ambassador|
  #     puts ambassador.id
  #   end
  #
  # @example Use with an ActiveRecord::Relation
  #   relation   = User.where(active: true)
  #   collection = AmbassadorCollection.new(relation, ambassador_class: UserAmbassador)
  #   collection.map(&:id)
  #
  # @example Enumerate lazily via Enumerator
  #   collection = AmbassadorCollection.new(users, ambassador_class: UserAmbassador)
  #   enum = collection.each
  #   first_two = [enum.next, enum.next]
  #
  class ::AmbassadorCollection
    require_relative "iterators"
    require "ambassadors/ambassador_factory"

    include Enumerable

    ##
    # If a batching strategy is used, load this number of records per batch
    # @return [Integer]
    DEFAULT_BATCH_SIZE = 1_000

    ##
    # Wraps an enumerable collection of entities in Ambassadors
    # @param enumerable [Enumerable]
    # @param ambassador_class [nil, Class]
    # @param batch_size [Integer] The number of records to load per batch (if not loading from memory)
    # @param iterator [Ambassadors::Iterators::IterationStrategy] Determines how to iterate over each item
    def initialize(enumerable,
                   ambassador_class: nil,
                   batch_size: DEFAULT_BATCH_SIZE,
                   iterator: Ambassadors::Iterators::IteratorResolver.resolve(
                     enumerable:
                   ))
      @enumerable = enumerable
      @iterator = iterator.new(enumerable: @enumerable, batch_size: batch_size)
      @ambassador_factory = AmbassadorFactory.new(default_ambassador_class: ambassador_class)
    end

    def each
      return enum_for(:each) unless block_given?

      @iterator.to_enum.each do |item|
        yield(@ambassador_factory.cast(item))
      end
    end

    ##
    # The number of items in the current collection
    # @return [Integer]
    def length
      @enumerable.length
    end

    alias size length
    alias count length

    ##
    # The entire collection. Returns self.
    # @return [self]
    def all
      # TODO: Revisit this decision?
      # This makes sense in terms of the entire collection _is_ the collection,
      # but it might not be the best implementation
      self
    end

    def take(index = nil)
      if index.nil?
        @enumerable.take(1)[0]
      else
        super
      end
    end
  end
end
