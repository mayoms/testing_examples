defmodule TestingExamples.ObservingGenServersTest do
  use ExUnit.Case, async: true

  alias TestingExamples.Permissions.Server

  test "genserver canns can be observed with :erlang.trace" do
    user_id = 1

    # alternatively we could have used `pid = start_supervised!(Server)`
    # if it wasn't already in the application supervisor tree
    pid = Process.whereis(Server)
    :erlang.trace(pid, true, [:receive])

    Server.get_user_permissions(user_id)

    assert_receive {:trace, ^pid, :receive, {:"$gen_call", _, {:get_permission, ^user_id}}},
                   1000
  end
end
