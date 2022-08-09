defmodule TestingExamples.Permissions.Server do
  use GenServer

  def start_link(_opts),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call({:get_permission, user_id}, _from, state) do
    resp =
      case Map.fetch(state, user_id) do
        :error -> {:error, "user not found"}
        permissions -> permissions
      end

    {:reply, resp, state}
  end

  def get_user_permissions(user_id) do
    GenServer.call(__MODULE__, {:get_permission, user_id})
  end
end
