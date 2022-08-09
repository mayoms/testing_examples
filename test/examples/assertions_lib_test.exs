defmodule TestingExamples.AssertionsLibTest do
  use ExUnit.Case
  import Assertions

  test "list equality" do
    list = Enum.to_list(1..10)
    shuffled = Enum.shuffle(list)

    # native
    refute list == shuffled
    assert list == Enum.sort(shuffled)

    # assertions
    assert_lists_equal(list, shuffled)
  end

  test "map equality" do
    one = %{key1: :val, key2: :val, key3: :val, timestamp: DateTime.utc_now()}
    two = %{key1: :val, key2: :val, key3: :val, timestamp: DateTime.utc_now()}

    # native
    refute one == two
    assert one.key1 == two.key1
    assert one.key2 == two.key2
    assert one.key3 == two.key3

    # assertions

    assert_maps_equal(one, two, [:key1, :key2, :key3])
  end

  defmodule S do
    defstruct [:key1, :key2, :key3, :timestamp]
  end

  test "struct equality" do
    one = %S{key1: :val, key2: :val, key3: :val, timestamp: DateTime.utc_now()}
    two = %S{key1: :val, key2: :val, key3: :val, timestamp: DateTime.utc_now()}

    # native
    refute one == two
    assert one.key1 == two.key1
    assert one.key2 == two.key2
    assert one.key3 == two.key3

    # assertions

    assert_structs_equal(one, two, [:key1, :key2, :key3])
  end
end
