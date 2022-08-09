defmodule ConnCase do
  use ExUnit.CaseTemplate
  alias TestingExamples.Router
  import Factory
  import Mox

  using do
    quote do
      use Plug.Test
      import ConnCase
      import Factory
      import Mox
    end
  end

  setup [
    :handle_user_tags,
    :handle_user_permissions,
    :add_conn_to_context
  ]

  # case set up functions -- has all the same rules as a setup block:
  # https://hexdocs.pm/ex_unit/main/ExUnit.Callbacks.html#setup/1

  def handle_user_tags(%{authenticated: true}), do: [user: insert(:user)]
  def handle_user_tags(%{internal_authenticated: true}), do: [user: insert(:internal_user)]
  def handle_user_tags(_), do: :ok

  def handle_user_permissions(%{user_permissions: user_permissions, user: %{id: user_id}})
      when is_list(user_permissions) do
    stub(PermissionMock, :get_user_permissions, fn ^user_id ->
      {:ok, user_permissions}
    end)

    :ok
  end

  def handle_user_permissions(_), do: :ok

  def add_conn_to_context(context) do
    conn =
      if Map.has_key?(context, :user) do
        %Plug.Conn{} |> Plug.Conn.put_req_header("x-user-id", to_string(context.user.id))
      else
        %Plug.Conn{}
      end

    [conn: conn]
  end

  # define helpers

  def get(conn, path, params_or_body \\ nil),
    do: Plug.Adapters.Test.Conn.conn(conn, :get, path, params_or_body) |> dispatch()

  def dispatch(conn), do: conn |> Router.call(Router.init([]))
end
