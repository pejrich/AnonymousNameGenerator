defmodule AnonymousNameGenerator do
  @moduledoc """
    This library will create Heroku-like names

    It can create random names like "pungent-slime"

    If you need more variation, you can generate names likes "pungent-slime-1234"

    It can also create consistent/consistent names if you pass in integers

    user = %User{id: 341, timestamp: 1530244444}
    ex. #{__MODULE__}.generate_consistent(user.id, user.timestamp)
    This will always give the same result.
  """
  @adjectives AnonymousNameGenerator.Adjective.adjectives
  @adjective_count @adjectives |> length
  def adjectives, do: @adjectives
  def adjective_count, do: @adjective_count
  
  @nouns AnonymousNameGenerator.Noun.nouns
  @noun_count @nouns |> length
  def nouns, do: @nouns
  def noun_count, do: @noun_count
  
  @default_num_possibilities @adjective_count * @noun_count

  # def multi_adj(adjective_count \\ 2) do
  #   adjs = (1..adjective_count)
  #   |> Enum.map(fn(_) -> 
  #     Enum.random(@adjectives)
  #   end)
  #   |> Enum.join("-")
  #   adjs <> "-" <> Enum.random(@nouns)
  # end

  @doc """
    This will create a new unique name on each call.
    By default, the number of possibilities are:
    num of adjectives multiplied by the num of nouns
    
    Adjectives: #{@adjective_count} * Nouns: #{@noun_count} =~ #{@adjective_count * @noun_count}

    Passing a param will add a number of more possibilities are needed.

    generate_random(1_000_000) = adj-noun-12
  """
  def generate_random(num_possibilities \\ nil)
  def generate_random(nil) do
    adj = Enum.random(@adjectives)
    noun = Enum.random(@nouns)
    adj <> "-" <> noun
  end
  def generate_random(num_possibilities) when is_integer(num_possibilities) do
    generate_random <> "-" <> get_random_numbers_for(num_possibilities)
  end

  @doc """
    This will always return the same result if the same params are passed.
    This can be used for giving the same name to a user
    For example __MODULE__.generate_consistent(user.id, user.inserted_at_unix))
  """
  def generate_consistent(a, b, num_possibilities \\ nil)
  def generate_consistent(a, b, nil) when is_integer(a) and is_integer(b) do
    adj = Enum.at(@adjectives, :erlang.phash2(a, @adjective_count))
    noun = Enum.at(@nouns, :erlang.phash2(b, @noun_count))
    adj <> "-" <> noun
  end
  def generate_consistent(a, b, num) when is_integer(a) and is_integer(b) do
    prefix = generate_consistent(a, b, nil)
    suffix = get_consistent_numbers_for(a, b, num)
    prefix <> "-" <> suffix
  end

  def get_random_numbers_for(num_possibilities) do
    1..numbers_needed_to_get_possibilities(num_possibilities)
    |> Enum.map(fn(_) -> :rand.uniform(10) - 1 end)
    |> Enum.join("")
  end

  def numbers_needed_to_get_possibilities(num) do
    :math.log10(num / @default_num_possibilities) 
    |> Float.ceil
    |> trunc
  end

  def get_consistent_numbers_for(a, b, num_possibilities) do
    nums_needed = numbers_needed_to_get_possibilities(num_possibilities)
    a_binary = Integer.to_string(a, 2) |> String.pad_leading(8, "0")
    b_binary = Integer.to_string(b, 2) |> String.pad_leading(8, "0")
    binary = get_binary_string_to_create_n_numbers(a_binary <> b_binary, nums_needed)
    create_n_numbers_from_binary(binary, nums_needed)
  end

  def get_binary_string_to_create_n_numbers(binary, num) do
    str_len = num * 5
    bin_len = binary |> String.length
    dup_times = (str_len / bin_len) |> Float.ceil |> trunc
    binary
    |> String.duplicate(dup_times)
  end

  def create_n_numbers_from_binary(binary, num) do
    binary
    |> String.codepoints
    |> Enum.chunk(5)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&(String.to_integer(&1, 2)))
    |> Enum.map(&(rem &1, 10))
    |> Enum.take(num)
    |> Enum.join
  end
end
