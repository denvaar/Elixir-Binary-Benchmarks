defmodule BinaryBenchmark do
  @moduledoc """
  Elixir and Erlang have several data structures that are commonly used as
  sequences. I recommend checking out [Saša Jurić's post about sequences](https://www.theerlangelist.com/article/sequences) for an overall comparison.

  What if we treat a binary / bitstring as a sequence data structure in Elixir?

  Bitvectors are used as the basis for many compact and succinct data structures
  like bloom filters, wavelet trees and more. A huge benefit of these data
  structures is that they are incredibly small in terms of memory usage, while still
  maintaining efficient runtime performance.

  It seems to me that the natural choice to represent a bitvector in Elixir is a
  bitstring.

      # example bitstring with four bits: 1010
      <<1::1, 0::1, 1::1, 0::1>>
      
      # approx size (in words) in memory
      :erts_debug.size(<<1::1, 0::1, 1::1, 0::1>>)
      # => 11

      # size in bytes
      byte_size(<<1::1, 0::1, 1::1, 0::1>>)
      # => 1

  I want to explore some common sequence operations, starting with random access
  reading.

  ## Random Access Reads

  One of the coolest things about Erlang/Elixir is the ability to pattern match
  on bitstrings and binaries. The idea for random access reading is that you can
  use a given `index` as an offset to select an `item`, which can either be one
  bit or byte (well, any size you'd like):

      # bind one bit to `item` at offset given by `index` from the string "hello world"
      <<_head::size(index), item::size(1), _tail::bitstring()>> = "hello world"

      # bind one byte instead
      <<_head::binary-size(index), item::binary-size(1), _tail::binary()>> = "hello world"

  I set up some benchmarks to observe the performance of doing random access
  reads into binaries of increasing sizes from 10 up to 1,000,000,000 bytes.

  Each benchmark does three random access reads on the binary of a given size.
  One access toward the front, one in the middle, and one toward the back. I tested
  accessing bits vs bytes separately.

  ## Random Bit Access

      10 bytes [bit access]                  84 ns
      100 bytes [bit access]                 84 ns
      1000 bytes [bit access]                84 ns
      10000 bytes [bit access]               84 ns
      100000 bytes [bit access]              84 ns
      1000000 bytes [bit access]             84 ns
      10000000 bytes [bit access]            84 ns
      100000000 bytes [bit access]           84 ns
      1000000000 bytes [bit access]          84 ns

  ## Random Binary Access

      10 bytes [byte access]                125 ns   
      100 bytes [byte access]               125 ns   
      1000 bytes [byte access]              125 ns   
      10000 bytes [byte access]             125 ns 
      100000 bytes [byte access]            125 ns   
      1000000 bytes [byte access]           125 ns   
      10000000 bytes [byte access]          125 ns   
      100000000 bytes [byte access]         125 ns   
      1000000000 bytes [byte access]        125 ns   

  So, it looks like accessing both bits and bytes has the same runtime performance no matter what the size of the binary is. This shouldn't come as much surprise since this is just pattern matching, but it still feels like a neat trick.

  I'm not sure why, but access is slightly quicker on bits than bytes.

  How does this compare to traditional sequences?

  ## Random List Access

  I already know that `List`s will be terrible, but I ran the tests anyway, just to see some numbers.

      10 items [list access]            0.00021 ms
      100 items [list access]           0.00071 ms
      1000 items [list access]          0.00538 ms
      10000 items [list access]          0.0516 ms
      100000 items [list access]           0.51 ms
      1000000 items [list access]          5.15 ms
      10000000 items [list access]        51.50 ms
      100000000 items [list access]      516.83 ms
      1000000000 items [list access]    6596.87 ms

  ## Random Tuple Access

  Here are the results for tuples, which should be well suited for random access reads. You can't make a tuple with more than 67,108,863 items, so the benchmark does not go up as high as the others.

      10 items [tuple access]               83 ns
      100 items [tuple access]              83 ns
      1000 items [tuple access]             83 ns
      10000 items [tuple access]            83 ns
      100000 items [tuple access]           83 ns
      1000000 items [tuple access]          83 ns
      10000000 items [tuple access]         83 ns

  ### Heap Memory Usage

  How do these sequences compare in terms of memory usage? Here are the results of checking `:erts_debug.size/1` for each type of sequence measured above. This is an undocumented function, but should count the amount of data a term uses on the heap.

      Binary (1000000 bytes)                      6 words
      Tuple (1000000 integer elements)      1000001 words
      List (1000000 integer elements)       2000000 words

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

  def access_random_list_index(data, seq) do
    Enum.map(seq, fn index -> Enum.at(data, index) end)
  end

  def access_random_tuple_index(data, seq) do
    Enum.map(seq, fn index -> elem(data, index) end)
  end

  @doc """
  Insert a 1 bit into `data` at given `index` and return
  new bitstring.
  """
  def insert_bit(data, index) do
    <<head::bits-size(index), tail::bitstring()>> = data
    <<head::bits-size(index), 1::size(1), tail::bitstring()>>
  end

  @doc """
  Insert 1 byte (letter "a") into `data` at given `index` and
  return new binary.
  """
  def insert_byte(data, index) do
    <<head::binary-size(index), tail::binary()>> = data
    <<head::binary-size(index), 97, tail::binary()>>
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
    |> Benchee.run(memory_time: 2)
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
    |> Benchee.run(memory_time: 2)
  end

  def benchmark_list() do
    binary_sizes()
    |> Enum.reduce(%{}, fn size, acc ->
      bin_list =
        size
        |> rand_binary()
        |> :binary.bin_to_list()

      indices = pick_lookup_indices(size)

      Map.put(acc, "#{size} items [list access]", fn ->
        access_random_list_index(bin_list, indices)
      end)
    end)
    |> Benchee.run(memory_time: 2)
  end

  @max_tuple 10_000_000

  def benchmark_tuple() do
    binary_sizes()
    |> Enum.reduce(%{}, fn size, acc ->
      size = min(size, @max_tuple)

      bin_tup =
        size
        |> rand_binary()
        |> :binary.bin_to_list()
        |> List.to_tuple()

      indices = pick_lookup_indices(size)

      Map.put(acc, "#{size} items [tuple access]", fn ->
        access_random_tuple_index(bin_tup, indices)
      end)
    end)
    |> Benchee.run(memory_time: 2)
  end

  def benchmark_insert_bit() do
    binary_sizes()
    |> Enum.reduce(%{}, fn size, acc ->
      bin = rand_binary(size)

      Map.put(acc, "#{size} bytes [bit insert]", fn ->
        insert_bit(bin, 0)
        insert_bit(bin, div(size * 8, 2))
        insert_bit(bin, size * 8)
      end)
    end)
    |> Benchee.run(memory_time: 2)
  end

  defp rand_binary(n_bytes) do
    :crypto.strong_rand_bytes(n_bytes)
  end
end
