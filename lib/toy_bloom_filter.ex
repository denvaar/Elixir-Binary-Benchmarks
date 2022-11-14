defmodule ToyBloomFilter do
  alias __MODULE__

  defstruct [:n_bits, :bitvector]

  @doc """
  Create an empty bloom filter with `n_bit` bits.
  """
  def create(n_bits) do
    %ToyBloomFilter{
      bitvector: <<0::size(n_bits)>>,
      n_bits: n_bits
    }
  end

  @doc """
  Add a member to the bloom filter set.
  """
  def add_member(
        %ToyBloomFilter{bitvector: <<bv::bits()>>, n_bits: n_bits} = bloom,
        <<query::binary()>>
      ) do
    {offset_1, offset_2, offset_3, offset_4} = offsets(query, n_bits)

    <<offset_chunk_bits_a::bits-size(offset_1), _::bits-size(1),
      offset_chunk_bits_b::bits-size(offset_2), _::bits-size(1),
      offset_chunk_bits_c::bits-size(offset_3), _::bits-size(1),
      offset_chunk_bits_d::bits-size(offset_4)>> = bv

    new_bv =
      <<offset_chunk_bits_a::bits-size(offset_1), 1::size(1),
        offset_chunk_bits_b::bits-size(offset_2), 1::size(1),
        offset_chunk_bits_c::bits-size(offset_3), 1::size(1),
        offset_chunk_bits_d::bits-size(offset_4)>>

    Map.put(bloom, :bitvector, new_bv)
  end

  @doc """
  Check of a given `query` is a member of the set.

  If the return value is `true`, then the `query` _might_ be a member.
  Otherwise, `query` is for sure not a member.
  """
  def possible_member?(
        %ToyBloomFilter{bitvector: <<bv::bits()>>, n_bits: n_bits},
        <<query::binary()>>
      ) do
    {offset_1, offset_2, offset_3, offset_4} = offsets(query, n_bits)

    do_possible_member?(bv, query, n_bits)
  end

  defp do_possible_member?(<<bv::bits()>>, <<query::binary()>>, n_bits) do
    {offset_1, offset_2, offset_3, offset_4} = offsets(query, n_bits)

    case bv do
      <<_offset_chunk_bits_a::bits-size(offset_1), 1::size(1),
        _offset_chunk_bits_b::bits-size(offset_2), 1::size(1),
        _offset_chunk_bits_c::bits-size(offset_3), 1::size(1),
        _offset_chunk_bits_d::bits-size(offset_4)>> ->
        true

      <<_::bits()>> ->
        false
    end
  end

  defp offsets(<<query::binary()>>, n_bits) do
    [h1, h2, h3] = get_hash_values(query, n_bits)

    offset_1 = h1
    offset_2 = h2 - h1 - 1
    offset_3 = h3 - h2 - 1
    offset_4 = n_bits - h3 - 1

    {offset_1, offset_2, offset_3, offset_4}
  end

  defp get_hash_values(<<query::binary()>>, n_bits) do
    h1 = :erlang.phash2(query, n_bits)
    h2 = :erlang.phash2([query], n_bits)

    bytes = byte_size(query)

    [
      rem(h1 + h2, n_bits),
      rem(h1 * h2 + 1, n_bits),
      rem(h1 - h2 * bytes + 1, n_bits)
    ]
    |> Enum.sort()
  end

  # defp h1(<<query::binary()>>) do
  #   :sha256
  #   |> :crypto.hash(query)
  #   |> :binary.bin_to_list()
  #   |> Enum.sum()
  # end

  # defp h2(<<query::binary()>>) do
  #   :sha512
  #   |> :crypto.hash(query)
  #   |> :binary.bin_to_list()
  #   |> Enum.sum()
  # end

  # defp get_hash_values(<<query::binary()>>, n_bits) do
  #   for i <- 1..3 do
  #     (h1(query) + h2(query) * i)
  #     |> rem(n_bits)
  #   end
  #   |> Enum.sort()
  # end
end
