defmodule AnonymousNameGeneratorTest do
  use ExUnit.Case
  doctest AnonymousNameGenerator

  alias AnonymousNameGenerator, as: ANG

  test "generate_random/0" do
    randoms = for i <- 1..10, do: ANG.generate_random
    assert Enum.uniq(randoms) |> length == 10
  end

  test "generate_random/1" do
    # Should add two extra numbers
    default_plus_two = default_num_possibilities * 10 * 10
    result = ANG.generate_random(default_plus_two)
    |> String.split("-")
    |> List.last
    assert result |> String.length == 2
    # Should add 3 extra numbers
    result = ANG.generate_random(default_plus_two + 1)
    |> String.split("-")
    |> List.last
    assert result |> String.length == 3
    # Should add no extra numbers, because default already covers the possibilities needed
    result = ANG.generate_random(10)
    |> String.split("-")
    |> length
    assert result == 2
  end

  test "generate_consistent/2" do
    randoms = for i <- 1..10 do
      ANG.generate_consistent(12, 21)
    end
    assert Enum.uniq(randoms) |> length == 1
  end

  test "generate_consistent/3" do
    randoms = for i <- 1..10 do
      ANG.generate_consistent(12, 21, default_num_possibilities * 10)
    end
    assert Enum.uniq(randoms) |> length == 1
    result = randoms
    |> List.last
    |> String.split("-")
    |> List.last
    assert result |> String.length == 1
  end

  defp default_num_possibilities do
    adjectives = ANG.Adjective.adjectives |> tuple_size
    nouns = ANG.Noun.nouns |> tuple_size
    adjectives * nouns
  end
end
