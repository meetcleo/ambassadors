[![Ruby](https://github.com/meetcleo/ambassadors/actions/workflows/main.yml/badge.svg)](https://github.com/meetcleo/ambassadors/actions/workflows/main.yml)

# Ambassadors

Immutable, read-only wrappers for your domain entities, designed for modular monoliths with explicit domain interfaces.

The core of this gem is the `Ambassador` class, with `AmbassadorCollection` as a supporting abstraction for iterating safely over many ambassadors.

- `Ambassador` - a frozen, read-only, stable façade over a domain entity.
- `AmbassadorCollection` - an `Enumerable` that always yields ambassador instances, with optional batching for heavy data sources (such as large ActiveRecord collections).

---

## Motivation

In a modular monolith, domain boundaries should be explicit.

Passing raw ORM models or deeply coupled objects across those boundaries makes refactors risky and leaks internal concerns everywhere.

**Ambassadors** are:

- Read-only views over your domain entities
- Explicit about what they expose
- Immutable once constructed

They are a safe value to return from **domain interface methods** to the outside world (other domains, adapters, controllers, etc.).

`AmbassadorCollection` then gives you a consistent way to work with many such ambassadors, regardless of the underlying source (e.g. `Array`, `ActiveRecord::Relation`, remote API results).

---

## Installation

Add to your Gemfile:

```ruby
gem "ambassadors"
```

Then:

```sh
bundle install
```

The Ruby namespace is `Ambassadors`.
For ergonomics, `Ambassador` and `AmbassadorCollection` are also defined as top-level constants.

## Defining an Ambassador

```ruby
class UserAmbassador < Ambassador
  expose :id, :email, :created_at
end
```

```ruby
user = User.find(...)
ambassador = UserAmbassador.new(user)
ambassador.id         # => 123
ambassador.email      # => "user@example.com"
ambassador.created_at # => 2025-01-01 12:34:56 UTC
```

### Key properties

- The ambassador instance is frozen in the constructor.
- Only methods declared with `expose` are generated and forwarded to the entity.
- Values returned from exposed properties are frozen.
- Property names ending in `!` or `=` cannot be exposed, and raise `Ambassadors::InvalidPropertyError`.

### `expose` DSL

```ruby
class CardAmbassador < Ambassador
  expose :id, :last4, :status
end
```

### Custom methods

Ambassador subclasses are ordinary Ruby classes, so you can define your own methods alongside exposed properties.
The wrapped entity is available via `entity`.

```ruby
class UserAmbassador < Ambassador
  expose :id, :first_name, :last_name

  def full_name
    "#{entity.first_name} #{entity.last_name}"
  end
end
```

### `#to_ambassador`

Every `Ambassador` responds to `#to_ambassador` and returns itself.
Entities may also implement `#to_ambassador` to control how they are cast (see [Ambassador casting](#ambassador-casting)).

## AmbassadorCollection

`AmbassadorCollection` is a thin wrapper that:

- Includes `Enumerable`
- Iterates using a strategy (plain `each`, `find_each`, etc.)
- Always yields ambassador instances

### Basic usage

```ruby
users = [User.new(name: "user A"), User.new(name: "user B")] # users is an Array of User objects
collection = AmbassadorCollection.new(users, ambassador_class: UserAmbassador)

collection.each do |ambassador|
  puts ambassador.email
end
```

### With ActiveRecord

Will safely iterate over `ActiveRecord::Relation` objects, without exposing dangerous methods (e.g. `delete_all`) or loading too many results at once.

```ruby
users = User.where(active: true) # users is an ActiveRecord::Relation
collection = AmbassadorCollection.new(users, ambassador_class: UserAmbassador)

collection.each do |ambassador| # loads in batches of 1000 by default
  puts ambassador.email
end
```

Specify an optional `batch_size:`:

```ruby
users = User.where(active: true)
collection = AmbassadorCollection.new(users, ambassador_class: UserAmbassador, batch_size: 50)

collection.each do |ambassador| # loads in batches of 50
  puts ambassador.email
end
```

Batches are loaded with `find_each`, ordered by the primary key ascending by default.
Pass `cursor:` and `order:` to batch on a different column or direction.
See the [ActiveRecord::Batches documentation](https://api.rubyonrails.org/classes/ActiveRecord/Batches.html#method-i-find_each) for the constraints on cursor columns.

```ruby
users = User.where(active: true)
collection = AmbassadorCollection.new(
  users,
  ambassador_class: UserAmbassador,
  cursor: :created_at,
  order: :desc
)
```

### Passing options to ambassadors

If your ambassador's constructor accepts keyword arguments, pass them to every ambassador in the collection with `ambassador_options:`.

```ruby
class UserAmbassador < Ambassador
  expose :id, :email

  def initialize(entity, include_profile: false)
    @include_profile = include_profile
    super(entity)
  end
end

collection = AmbassadorCollection.new(
  users,
  ambassador_class: UserAmbassador,
  ambassador_options: { include_profile: true }
)
```

### Collection helpers

Alongside the `Enumerable` methods, `AmbassadorCollection` provides:

- `#length`, `#size`, `#count` - the number of items in the underlying collection
- `#empty?` - whether the underlying collection has no items
- `#take` - the first ambassador, or the first `n` ambassadors when given a count
- `#all` - returns the collection itself

## Ambassador casting

Ambassadors will be cast based on the following strategies, in the order listed:

- Call `#to_ambassador` on the entity in the current iteration (if it responds to it).
- Use the provided `ambassador_class` to initialize a new ambassador for the entity.
- Infer the ambassador class name from the entity's class name (e.g. `User` => `UserAmbassador`).

If no strategy succeeds, the collection will raise `Ambassadors::UresolvedAmbassadorError`.

## Rails integration

When loaded inside a Rails application, the gem registers a Railtie that includes `ActiveModel::Serialization` in `Ambassador` once ActiveModel has loaded.
Ambassador subclasses that define an `attributes` method can then be serialised with the standard ActiveModel API (`serializable_hash`, `as_json`, and so on).

---

## Development

Run tests:

```sh
bundle exec rake test
```

Run guard:

```sh
bundle exec guard
```

Lint:

```sh
bundle exec rubocop
```

Run everything (tests and lint):

```sh
bundle exec rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meetcleo/ambassadors.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

MIT. See [LICENSE](LICENSE.txt) for details.
