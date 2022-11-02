defmodule BinaryBenchmark do
  @moduledoc """
  Elixir and Erlang have several data structures that are commonly used as
  sequences. I recommend checking out [Saša Jurić's post about sequences](https://www.theerlangelist.com/article/sequences) for an overall comparison.

  What if we treat a binary / bitstring as a sequence data structure in Elixir?

  Bitvectors are used as the basis for many compact and succinct data structures
  like bloom filters, wavelet trees and more. A huge benefit of these data
  structures is that they are incredibly small in terms of memory usage, while still
  maintaining efficient runtime performance. The natural choice to represent a
  bitvector in Elixir seems to me to be a bitstring.

      # example bitstring with four bits: 1010
      <<1::1, 0::1, 1::1, 0::1>>
      
      # approx size (in words) in memory
      :erts_debug.size(<<1::1, 0::1, 1::1, 0::1>>)
      # => 11

      # size in bytes
      byte_size(<<1::1, 0::1, 1::1, 0::1>>)
      # => 1

  Elixir provides some nice ways to interact with binaries / bitstrings by way
  of pattern matching.

  The idea is that you can use a given `index` as an offset to select an `item`,
  which can either be one bit or byte (well, any size you'd like):

      # select one bit
      <<_head::size(index), item::size(1), _tail::bitstring()>> = "hello world"

      # select one byte
      <<_head::binary-size(index), item::binary-size(1), _tail::binary()>> = "hello world"

  I set up some benchmarks to observe the performance of doing random access
  reads into binaries of increasing sizes from 10 up to 1,000,000,000 bytes.

  Each benchmark does three random access reads on the binary of the given size.
  One access toward the front, one in the middle, and one toward the back. I tested
  accessing bits vs bytes separately.

  ## Bit Access

      10 bytes [bit access]                  84 ns
      100 bytes [bit access]                 84 ns
      1000 bytes [bit access]                84 ns
      10000 bytes [bit access]               84 ns
      100000 bytes [bit access]              84 ns
      1000000 bytes [bit access]             84 ns
      10000000 bytes [bit access]            84 ns
      100000000 bytes [bit access]           84 ns
      1000000000 bytes [bit access]          84 ns

  ## Binary Access

      10 bytes [byte access]                125 ns   
      100 bytes [byte access]               125 ns   
      1000 bytes [byte access]              125 ns   
      10000 bytes [byte access]             125 ns 
      100000 bytes [byte access]            125 ns   
      1000000 bytes [byte access]           125 ns   
      10000000 bytes [byte access]          125 ns   
      100000000 bytes [byte access]         125 ns   
      1000000000 bytes [byte access]        125 ns   

  So, it looks like accessing both bits and bytes has the same runtime performance
  no matter what the size of the binary is. Access is slightly quicker on bits than
  bytes.

  """

  def access_random_bits(data, seq) do
    Enum.map(seq, fn index ->
      <<_head_offset::size(index), target_item::size(1), _tail::bitstring()>> = data

      target_item
    end)
  end

  def access_random_bytes(data, seq) do
    Enum.map(seq, fn index ->
      <<_head_offset::binary-size(index), target_item::binary-size(1), _tail::binary()>> = data

      target_item
    end)
  end

  defp binary_sizes() do
    [
      10,
      100,
      1_000,
      10_000,
      100_000,
      1_000_000,
      10_000_000,
      100_000_000,
      1_000_000_000
    ]
  end

  def pick_lookup_indices(size) do
    Enum.map(
      [0.333, 0.5, 0.666],
      fn n -> floor(size * n) end
    )
  end

  def benchmark_bits() do
    binary_sizes()
    |> Enum.reduce(%{}, fn size, acc ->
      bin = rand_binary(size)
      indices = pick_lookup_indices(size * 8)

      Map.put(acc, "#{size} bytes [bit access]", fn ->
        access_random_bits(bin, indices)
      end)
    end)
    |> Benchee.run()
  end

  def benchmark_bytes() do
    binary_sizes()
    |> Enum.reduce(%{}, fn size, acc ->
      bin = rand_binary(size)
      indices = pick_lookup_indices(size)

      Map.put(acc, "#{size} bytes [byte access]", fn ->
        access_random_bytes(bin, indices)
      end)
    end)
    |> Benchee.run()
  end

  defp rand_binary(n_bytes) do
    :crypto.strong_rand_bytes(n_bytes)
  end
end
