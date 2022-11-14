defmodule Bitvector do
  @doc """
  Number of set bits up to given `index`.
  """
  @spec rank(bitstring(), non_neg_integer()) :: non_neg_integer()
  def rank(bits, index)

  def rank(_bits, 0), do: 0

  def rank(<<b::bits()>>, index) do
    <<head::bits-size(index), _remaining::bits()>> = b

    Popcount.popcount_bitstring(head)
  end

  @doc """
  Index of the `i`-th set bit.
  """
  @spec select(bitstring(), non_neg_integer()) :: non_neg_integer()
  def select(_bits, _i) do
    :todo
  end

  @doc """
  Create an auxiliary bit vector to store the cumulative
  ranks from the given bit vector, `b`.

  Move through `b`, which has a bit length of `n`, in chunks of length (log₂n)² bits to calculate each chunk's cumulative rank.

      [<-- n bits --------------------------------->]  
      | (log₂n)² bit chunk |
                           | (log₂n)² bit chunk |

  The "cumulative rank" is the number of set bits up to the start of each chunk.

      [<-- n bits --------------------------------->]  
      [ chunk 1][ chunk 2][ chunk 3][ chunk 4] ... 
      [01100000][01100101][01100100][01111000] ... 
      [ 0      ][ 0+2=2  ][ 2+4=6  ][ 6+3=9  ] ...

  Make an auxiliary bit vector to store these cumulative ranks. Since the integer values are accumulated from chunk to chunk, the maximum possible rank value approaches n. 

  The auxiliary bit vector needs to store n / (log₂n)² cumulative ranks (eg. as many ranks as there are chunks). Each rank value is an integer that can be stored in log₂n bits, so the total additional space required is:
        
      O(log₂n * [n / (log₂n)²])
      ≈ O(n / log₂n)
      ≈ ǒ(n)

  ## Examples

  iex> bv = for byte <- 1..32, into: <<>>, do: <<byte>>
  ...> Bitvector.build_cumulative_ranks(bv)
  <<0, 13, 33, 54>>

  """
  @spec build_cumulative_ranks(bitstring()) :: bitstring()
  def build_cumulative_ranks(<<b::bits()>>) do
    n = bit_size(b)

    chunk_size =
      n
      |> :math.log2()
      |> Kernel.**(2)
      |> :math.ceil()
      |> trunc()

    cr_max_bit_width =
      n
      |> :math.log2()
      |> :math.ceil()
      |> trunc()

    IO.inspect(cr_max_bit_width)

    chunk_step = chunk_size..(n - chunk_size)//chunk_size
    initial_state = {0, <<0::size(cr_max_bit_width)>>}

    chunk_step
    |> Enum.reduce(initial_state, fn index, {prev_cr, cumulative_ranks} ->
      offset = index - chunk_size
      <<_::bits-size(offset), chunk::bits-size(chunk_size), _::bits()>> = b

      cr = Popcount.popcount_bitstring(chunk) + prev_cr

      {
        cr,
        <<cumulative_ranks::bits(), cr::size(cr_max_bit_width)>>
      }
    end)
    |> elem(1)
  end

  def build_relative_ranks(<<b::bits()>>) do
    n = bit_size(b)

    sub_chunk_size =
      n
      |> :math.log2()
      |> Kernel.*(2)
      |> :math.ceil()
      |> trunc()

    rr_max_bit_width =
      n
      |> :math.log2()
      |> Kernel.**(2)
      |> :math.log2()
      |> :math.ceil()
      |> trunc()

    IO.inspect(rr_max_bit_width)

    step = sub_chunk_size..(n - sub_chunk_size)//sub_chunk_size
    initial_state = <<0::size(rr_max_bit_width)>>

    step
    |> Enum.reduce(initial_state, fn index, relative_ranks ->
      offset = index - sub_chunk_size
      <<_::bits-size(offset), sub_chunk::bits-size(sub_chunk_size), _::bits()>> = b

      rr = Popcount.popcount_bitstring(sub_chunk)

      <<relative_ranks::bits(), rr::size(rr_max_bit_width)>>
    end)
  end
end
