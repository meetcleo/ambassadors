## [Unreleased]

## [0.1.0] - 2026-09-23

Initial public release.

- `Ambassador` base class with the `expose` DSL for read-only, frozen properties.
- `AmbassadorCollection` for enumerating entities as ambassadors, with batched iteration for `ActiveRecord::Relation`.
- `ambassador_options:` for passing keyword arguments through to each ambassador's constructor.
- `cursor:` and `order:` options to control batched iteration.
- `Ambassador#to_ambassador` for polymorphic casting.
- Optional Rails integration that includes `ActiveModel::Serialization` in `Ambassador` when available.
