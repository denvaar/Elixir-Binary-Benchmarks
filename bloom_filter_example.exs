defmodule BloomFilterExample do
  def run() do
    bloom = ToyBloomFilter.create(100_000_000)

    :erlang.garbage_collect()
    IO.inspect(:erlang.process_info(self(), :binary), label: "point a")

    bloom =
      Enum.reduce(0..2, bloom, fn _i, acc ->
        IO.inspect(:erlang.process_info(self(), :binary), label: "point b")

        ToyBloomFilter.add_member(
          acc,
          :crypto.strong_rand_bytes(10)
        )
      end)

    :erlang.garbage_collect()

    IO.inspect(:erlang.process_info(self(), :binary), label: "point c")
    bloom
  end
end

BloomFilterExample.run()
