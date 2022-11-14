defmodule BinariesAndBitstrings do
  @moduledoc """

  ##### With input n=10 #####
  Name                              ips        average  deviation         median         99th %
  Random access tuple            3.26 M      307.03 ns  ±9812.49%         208 ns         333 ns
  Random access bitstring        3.10 M      322.58 ns  ±7446.68%         250 ns         375 ns
  Random access map              2.89 M      346.11 ns  ±7715.95%         291 ns         375 ns
  Random access list             1.59 M      628.76 ns  ±3132.26%         583 ns         709 ns

  Comparison:
  Random access tuple            3.26 M
  Random access bitstring        3.10 M - 1.05x slower +15.55 ns
  Random access map              2.89 M - 1.13x slower +39.08 ns
  Random access list             1.59 M - 2.05x slower +321.73 ns

  Memory usage statistics:

  Name                       Memory usage
  Random access tuple               376 B
  Random access bitstring           776 B - 2.06x memory usage +400 B
  Random access map                 376 B - 1.00x memory usage +0 B
  Random access list                536 B - 1.43x memory usage +160 B

  **All measurements for memory usage were the same**

  ##### With input n=100 #####
  Name                              ips        average  deviation         median         99th %
  Random access bitstring        3.12 M      320.26 ns  ±7155.00%         250 ns         375 ns
  Random access map              2.13 M      470.00 ns  ±4710.56%         375 ns         500 ns
  Random access tuple            1.37 M      730.68 ns  ±9522.39%         208 ns         625 ns
  Random access list             0.40 M     2523.30 ns   ±590.49%        2417 ns        2750 ns

  Comparison:
  Random access bitstring        3.12 M
  Random access map              2.13 M - 1.47x slower +149.73 ns
  Random access tuple            1.37 M - 2.28x slower +410.42 ns
  Random access list             0.40 M - 7.88x slower +2203.03 ns

  Memory usage statistics:

  Name                       Memory usage
  Random access bitstring           776 B
  Random access map                 376 B - 0.48x memory usage -400 B
  Random access tuple               376 B - 0.48x memory usage -400 B
  Random access list                536 B - 0.69x memory usage -240 B

  **All measurements for memory usage were the same**

  ##### With input n=1000 #####
  Name                              ips        average  deviation         median         99th %
  Random access tuple            3.37 M      296.79 ns ±10132.73%         208 ns         333 ns
  Random access bitstring        3.11 M      321.44 ns  ±7148.23%         250 ns         375 ns
  Random access map              2.06 M      486.38 ns  ±4947.61%         417 ns         500 ns
  Random access list           0.0685 M    14593.37 ns    ±20.00%       14541 ns       16292 ns

  Comparison:
  Random access tuple            3.37 M
  Random access bitstring        3.11 M - 1.08x slower +24.65 ns
  Random access map              2.06 M - 1.64x slower +189.59 ns
  Random access list           0.0685 M - 49.17x slower +14296.58 ns

  Memory usage statistics:

  Name                       Memory usage
  Random access tuple               376 B
  Random access bitstring           776 B - 2.06x memory usage +400 B
  Random access map                 376 B - 1.00x memory usage +0 B
  Random access list                536 B - 1.43x memory usage +160 B

  **All measurements for memory usage were the same**

  ##### With input n=10000 #####
  Name                              ips        average  deviation         median         99th %
  Random access tuple            3.35 M      298.23 ns ±10235.02%         208 ns         333 ns
  Random access bitstring        3.17 M      315.85 ns  ±7037.95%         250 ns         375 ns
  Random access map              1.98 M      504.07 ns  ±3697.83%         458 ns         542 ns
  Random access list          0.00497 M   201011.46 ns     ±2.48%      199249 ns   216499.73 ns

  Comparison:
  Random access tuple            3.35 M
  Random access bitstring        3.17 M - 1.06x slower +17.63 ns
  Random access map              1.98 M - 1.69x slower +205.84 ns
  Random access list          0.00497 M - 674.02x slower +200713.24 ns

  Memory usage statistics:

  Name                       Memory usage
  Random access tuple               376 B
  Random access bitstring           776 B - 2.06x memory usage +400 B
  Random access map                 376 B - 1.00x memory usage +0 B
  Random access list                536 B - 1.43x memory usage +160 B

  **All measurements for memory usage were the same**

  ##### With input n=100000 #####
  Name                              ips        average  deviation         median         99th %
  Random access tuple            3.72 M      268.90 ns  ±7549.50%         208 ns         333 ns
  Random access bitstring        3.13 M      319.29 ns  ±7014.54%         250 ns         375 ns
  Random access map              1.97 M      508.90 ns  ±3360.00%         458 ns         583 ns
  Random access list          0.00047 M  2134523.09 ns     ±1.99%  2123035.50 ns  2278987.01 ns

  Comparison:
  Random access tuple            3.72 M
  Random access bitstring        3.13 M - 1.19x slower +50.39 ns
  Random access map              1.97 M - 1.89x slower +240.00 ns
  Random access list          0.00047 M - 7937.93x slower +2134254.19 ns

  Memory usage statistics:

  Name                       Memory usage
  Random access tuple               376 B
  Random access bitstring           776 B - 2.06x memory usage +400 B
  Random access map                 376 B - 1.00x memory usage +0 B
  Random access list                536 B - 1.43x memory usage +160 B

  **All measurements for memory usage were the same**

  ##### With input n=1000000 #####
  Name                              ips        average  deviation         median         99th %
  Random access bitstring        3.09 M      323.18 ns  ±7088.09%         250 ns         375 ns
  Random access map              1.90 M      526.54 ns  ±5828.01%         458 ns         542 ns
  Random access tuple            0.70 M     1438.01 ns  ±7300.95%         292 ns         750 ns
  Random access list          0.00007 M 14427215.82 ns     ±1.40%    14346166 ns 15348438.32 ns

  Comparison:
  Random access bitstring        3.09 M
  Random access map              1.90 M - 1.63x slower +203.36 ns
  Random access tuple            0.70 M - 4.45x slower +1114.83 ns
  Random access list          0.00007 M - 44641.40x slower +14426892.64 ns

  Memory usage statistics:

  Name                       Memory usage
  Random access bitstring           776 B
  Random access map                 376 B - 0.48x memory usage -400 B
  Random access tuple               376 B - 0.48x memory usage -400 B
  Random access list                536 B - 0.69x memory usage -240 B

  **All measurements for memory usage were the same**

  ##### With input n=10000000 #####
  Name                              ips        average  deviation         median         99th %
  Random access tuple            4.84 M      206.49 ns  ±3638.93%         208 ns         292 ns
  Random access map              1.81 M      552.19 ns ±14517.31%         459 ns        1542 ns
  Random access bitstring        0.95 M     1051.99 ns  ±7374.05%         250 ns        1458 ns
  Random access list          0.00001 M 91034580.98 ns     ±0.56%    90945736 ns    92799481 ns

  Comparison:
  Random access tuple            4.84 M
  Random access map              1.81 M - 2.67x slower +345.70 ns
  Random access bitstring        0.95 M - 5.09x slower +845.51 ns
  Random access list          0.00001 M - 440875.96x slower +91034374.50 ns

  Memory usage statistics:

  Name                       Memory usage
  Random access tuple               376 B
  Random access map                 376 B - 1.00x memory usage +0 B
  Random access bitstring           776 B - 2.06x memory usage +400 B
  Random access list                536 B - 1.43x memory usage +160 B

  **All measurements for memory usage were the same**

  ##### With input n=100000000 #####
  Name                              ips        average  deviation         median         99th %
  Random access tuple        13980.18 K      0.0715 μs ±38187.14%      0.0420 μs      0.0840 μs
  Random access bitstring      950.52 K        1.05 μs  ±7342.92%        0.25 μs        1.50 μs
  Random access map            872.86 K        1.15 μs ±84711.27%        0.46 μs        1.58 μs
  Random access list          0.00051 K  1950848.05 μs     ±1.09%  1941214.49 μs  1975219.22 μs

  Comparison:
  Random access tuple        13980.18 K
  Random access bitstring      950.52 K - 14.71x slower +0.98 μs
  Random access map            872.86 K - 16.02x slower +1.07 μs
  Random access list          0.00051 K - 27273203.07x slower +1950847.98 μs

  Memory usage statistics:

  Name                       Memory usage
  Random access tuple                56 B
  Random access bitstring           776 B - 13.86x memory usage +720 B
  Random access map                 376 B - 6.71x memory usage +320 B
  Random access list                536 B - 9.57x memory usage +480 B

  **All measurements for memory usage were the same**

  ##### With input n=1000000000 #####
  Name                              ips        average  deviation         median         99th %
  Random access tuple       15260429.50      0.00000 s ±26677.80%      0.00000 s      0.00000 s
  Random access bitstring     951534.07      0.00000 s  ±7304.01%      0.00000 s      0.00000 s
  Random access map              159.89      0.00625 s     ±0.00%      0.00625 s      0.00625 s
  Random access list             0.0533        18.76 s     ±0.00%        18.76 s        18.76 s

  Comparison:
  Random access tuple       15260429.50
  Random access bitstring     951534.07 - 16.04x slower +0.00000 s
  Random access map              159.89 - 95440.47x slower +0.00625 s
  Random access list             0.0533 - 286257768.53x slower +18.76 s

  Memory usage statistics:

  Name                       Memory usage
  Random access tuple                56 B
  Random access bitstring           776 B - 13.86x memory usage +720 B
  Random access map                 376 B - 6.71x memory usage +320 B
  Random access list                536 B - 9.57x memory usage +480 B
  """

  def benchmark() do
    all_n = [
      10,
      100,
      1000,
      10000,
      100_000,
      1_000_000,
      10_000_000,
      100_000_000,
      1_000_000_000
    ]

    m = 10

    inputs = for i <- all_n, into: %{}, do: {"n=#{i}", i}

    %{
      # "Random access tuple" =>
      #   {fn {tuple, indices} ->
      #      for index <- indices do
      #        target_item = elem(tuple, index)
      #        target_item
      #      end
      #    end,
      #    before_scenario: fn n ->
      #      if n <= 10_000_000 do
      #        tuple = for(i <- 0..(n - 1), do: i) |> List.to_tuple()

      #        indices = for _i <- 1..m, do: :rand.uniform(n - 1)
      #        {tuple, indices}
      #      else
      #        {{}, []}
      #      end
      #    end},
      # "Random access list" =>
      #   {fn {list, indices} ->
      #      for index <- indices do
      #        target_item = Enum.at(list, index)
      #        target_item
      #      end
      #    end,
      #    before_scenario: fn n ->
      #      list = for i <- 0..(n - 1), do: i
      #      indices = for _i <- 1..m, do: :rand.uniform(n - 1)

      #      {list, indices}
      #    end},
      # "Random access map" =>
      #   {fn {map, indices} ->
      #      for index <- indices do
      #        target_item = Map.get(map, index)
      #        target_item
      #      end
      #    end,
      #    before_scenario: fn n ->
      #      map = for i <- 0..(n - 1), into: %{}, do: {i, i}
      #      indices = for _i <- 1..m, do: :rand.uniform(n - 1)
      #      {map, indices}
      #    end},
      "Random access bitstring" =>
        {fn {<<bits::bits()>>, indices} ->
           for index <- indices do
             <<_head_offset::size(index), target_item::size(1), _tail::bits()>> = bits
             target_item
           end
         end,
         before_scenario: fn n ->
           bits = for <<(<<i::bits-size(1)>> <- <<0::size(n)>>)>>, into: <<>>, do: i
           indices = for _i <- 1..m, do: :rand.uniform(n - 1)
           {bits, indices}
         end}
    }
    |> Benchee.run(memory_time: 2, inputs: inputs)
  end
end
