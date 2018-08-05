# AnonymousNameGenerator

Create Heroku-like names randomly, or consistently (based on inputs).

## Installation

Add `anonymous_name_generator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:anonymous_name_generator, "~> 0.1.2"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/anonymous_name_generator](https://hexdocs.pm/anonymous_name_generator).

## Usage

### `generate_random/0` and `generate_random/1`

These are used to generate a random name. The default number of possibilities is ~138,000. If you need more, add an integer to include a number along with the name.

```elixir
generate_random()
=> "slushy-billboard"
generate_random()
=> "slushy-billboard"
generate_random(100_000)
=> "weak-jewel"
generate_random(1_000_000_000)
=> "powerful-emu-1455"
```

### `generate_consistent/2` and `generate_consistent/3`

These are using if you want predictable/consistent names. For example if you want to add names to users, you could pick any two integers for that user (e.g. ID, and inserted_at unix timestamp).

```elixir
user = %User{id: 123, timestamp: 1533440961}

generate_consistent(user.id, user.timestamp)
=> "massive-motel"
generate_consistent(user.id, user.timestamp, 1_000_000_000)
=> "massive-motel-5472"
```

Every time you call `generate_consistent/2`/`generate_consistent/3` with the same input, it'll return the same output.



## License

MIT

## Changelog

#### v 0.1.0

* Initial Release

#### v 0.1.1

* sped up generate_random by using `:rand.uniform` instead of `Enum.random`

#### v 0.1.2

* Added `@moduledoc false` to `noun.ex` and `adjective.ex`

#### v 0.1.3

* Fix typo
* Performance boost by switching from noun/adj. using lists and `Enum.at/2`, to using `elem/2` and tuples.
