defmodule TestingExamplesTest do
  use ExUnit.Case

  @moduletag :authenticated

  test "is authenticated in a test block", context do
    assert context[:authenticated]
  end

  describe "describetag" do
    @describetag authenticated: nil

    test "overrides @moduletag", context do
      assert is_nil(context[:authenticated])
    end

    @tag :authenticated
    test "@tag overrides @moduletag", context do
      assert context[:authenticated]
    end
  end
end
