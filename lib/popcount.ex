defmodule Popcount do
  lookups =
    for i <- 0..1,
        j <- 0..1,
        k <- 0..1,
        l <- 0..1,
        m <- 0..1,
        n <- 0..1,
        o <- 0..1,
        p <- 0..1 do
      {<<i::1, j::1, k::1, l::1, m::1, n::1, o::1, p::1>>, i + j + k + l + m + n + o + p}
    end

  @doc """
  Count number of set bits for a given byte.
  """
  @spec popcount_byte(<<_::1, _::_*8>>) :: non_neg_integer()
  def popcount_byte(byte)

  for {pattern, popcount} <- lookups do
    def popcount_byte(unquote(pattern)), do: unquote(popcount)
  end

  @doc """
  Count number of set bits for a given bitstring.
  """
  @spec popcount_binary(binary()) :: non_neg_integer()
  def popcount_binary(bin) do
    popcount_binary_sum(bin, 0)
  end

  defp popcount_binary_sum(<<>>, count), do: count

  defp popcount_binary_sum(<<byte::binary-size(1), remaining_bytes::binary()>>, count) do
    popcount_binary_sum(
      remaining_bytes,
      count + popcount_byte(byte)
    )
  end

  @doc """
  Count number of set bits for a given bitstring.
  """
  @spec popcount_bitstring(bitstring()) :: non_neg_integer()
  def popcount_bitstring(bits) do
    popcount_bits_sum(bits, 0)
  end

  defp popcount_bits_sum(<<>>, count), do: count

  defp popcount_bits_sum(<<byte::binary-size(1), remaining_bits::bits()>>, count) do
    popcount_bits_sum(
      remaining_bits,
      count + popcount_byte(byte)
    )
  end

  defp popcount_bits_sum(<<bit::bits-size(1), remaining_bits::bits()>>, count) do
    popcount_bits_sum(
      remaining_bits,
      bit_value(bit) + count
    )
  end

  # @compile {:inline, bit_value: 1}

  @spec bit_value(<<_::1, _::_*1>>) :: non_neg_integer()
  defp bit_value(<<bit::bits-size(1)>>) do
    case bit do
      <<1::size(1)>> -> 1
      <<0::size(1)>> -> 0
    end
  end
end
