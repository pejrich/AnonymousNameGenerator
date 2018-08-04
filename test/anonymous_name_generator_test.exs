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

  # test "multi_adj/0" do
  #   res = ANG.multi_adj
  #   assert String.split(res, "-") |> length == 3
  # end

  # test "multi_adj/1" do
  #   res = ANG.multi_adj(3)
  #   assert String.split(res, "-") |> length == 4
  # end

  test "numbers_needed_to_get_possibilities/1" do
    assert ANG.numbers_needed_to_get_possibilities(10) == 0
    assert ANG.numbers_needed_to_get_possibilities(0) == 0
    assert ANG.numbers_needed_to_get_possibilities(default_num_possibilities * 10 * 10) == 2
    assert ANG.numbers_needed_to_get_possibilities((default_num_possibilities * 10 * 10) + 1) == 3
  end

  test "get_binary_string_to_create_n_numbers/2" do
    binary = "0101010101010101"
    bin = ANG.get_binary_string_to_create_n_numbers(binary, 4)
    assert bin == String.duplicate(binary, 2)
  end

  test "create_n_numbers_from_binary/2" do
    binary = "01001001010001000111" 
    assert ANG.create_n_numbers_from_binary(binary, 4) == "9527"
    binary  = "000000000000000"
    assert ANG.create_n_numbers_from_binary(binary, 3) == "000"
    binary  = "00001000010000100001"
    assert ANG.create_n_numbers_from_binary(binary, 4) == "1111"
  end

  test "get_consistent_numbers_for/3" do
    milli = ANG.get_consistent_numbers_for(1, 2, 1_000_000) == "04"
    billi = ANG.get_consistent_numbers_for(4, 6, 1_000_000_000) == "0406308"
  end

  defp default_num_possibilities do
    adjectives = ANG.Adjective.adjectives |> length
    nouns = ANG.Noun.nouns |> length
    adjectives * nouns
  end
end
