# Ambassadors

Immutable, read-only wrappers for your domain entities, designed for modular / modularised monoliths with explicit domain interfaces.

The core of this gem is the `Ambassador` class, with `AmbassadorCollection` as a supporting abstraction for iterating safely over many ambassadors.

- `Ambassador` – a frozen, read-only, stable façade over a domain entity.
- `AmbassadorCollection` – an `Enumerable` that always yields ambassador instances, with optional batching for heavy data sources (such as large ActiveRecord collections).

---

## Motivation

In a modular monolith, domain boundaries should be explicit. 

Passing raw ORM models or deeply coupled objects across those boundaries makes refactors risky and leaks internal concerns everywhere.

**Ambassadors** are:

- Read-only views over your domain entities
- Explicitly whitelisted in what they expose
- Immutable once constructed

They are a safe value to return from **domain interface methods** to the outside world (other domains, adapters, controllers, etc.).

`AmbassadorCollection` then gives you a consistent way to work with many such ambassadors, regardless of the underlying source (e.g. `Array`, `ActiveRecord::Relation`, remote API results).

---

## Installation

Add to your Gemfile:

```ruby
gem "ambassadors"
```

```ruby
gem "ambassadors"
```

Then:

`bundle install`


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


### Key properties:

You must pass the domain entity to #initialize.
The ambassador instance is frozen in the constructor.
Only methods declared with expose are generated and exposed.

### expose DSL

```ruby
class CardAmbassador < Ambassador
  expose :id, :last4, :status
end
```

### AmbassadorCollection

AmbassadorCollection is a thin wrapper that:
- Includes Enumerable
- Iterates using a strategy (plain each, find_each, remote paging (TODO), etc.) 
- Always yields ambassador instances


#### Basic usage

```ruby
users = User.where(active: true)
collection = AmbassadorCollection.new(users, ambassador_class: UserAmbassador)

collection.each do |ambassador|
  puts ambassador.email
end
```


## Development

Run tests:

`bundle exec rake test`

Run guard (if configured):

`bundle exec guard`

Lint:

`bundle exec rubocop`

License

MIT. See [LICENSE] for details
