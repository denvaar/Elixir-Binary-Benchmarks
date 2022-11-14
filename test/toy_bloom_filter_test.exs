defmodule ToyBloomFilterTest do
  use ExUnit.Case

  test "Added members \"might\" exist" do
    bloom =
      ToyBloomFilter.create(32)
      |> ToyBloomFilter.add_member("cats")

    assert ToyBloomFilter.possible_member?(bloom, "cats") == true

    bloom =
      bloom
      |> ToyBloomFilter.add_member("dogs")
      |> ToyBloomFilter.add_member("snakes")

    assert ToyBloomFilter.possible_member?(bloom, "dogs") == true
    assert ToyBloomFilter.possible_member?(bloom, "snakes") == true
  end

  test "Membership check failure means query is definitely not in set" do
    bloom =
      ToyBloomFilter.create(32)
      |> ToyBloomFilter.add_member("cats")
      |> ToyBloomFilter.add_member("zebras")
      |> ToyBloomFilter.add_member("snakes")

    # Since this comes back false, we can definitely say that
    # "rats" is not a member of the set.
    #
    # However, that's not to say that as the set grows it will
    # always be the case...
    refute ToyBloomFilter.possible_member?(bloom, "rats")

    bloom =
      bloom
      |> ToyBloomFilter.add_member("donkeys")
      |> ToyBloomFilter.add_member("lions")
      |> ToyBloomFilter.add_member("tigers")
      |> ToyBloomFilter.add_member("penguins")
      |> ToyBloomFilter.add_member("muskrats")
      |> ToyBloomFilter.add_member("monkeys")
      |> ToyBloomFilter.add_member("bugs")
      |> ToyBloomFilter.add_member("elephants")

    # Now we get a false positive.
    #
    # "rats" is still not a member, but we cannot say that
    # for certain anymore.
    assert ToyBloomFilter.possible_member?(bloom, "rats")
  end
end
