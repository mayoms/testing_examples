defmodule BaseCase do
  import Factory

  def setup_repo_sandbox(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestingExamples.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TestingExamples.Repo, {:shared, self()})
    end

    :ok
  end

  # case set up functions -- has all the same rules as a setup block:
  # https://hexdocs.pm/ex_unit/main/ExUnit.Callbacks.html#setup/1

  def handle_user_tags(%{authenticated: true}), do: [user: insert(:user)]
  def handle_user_tags(%{internal_authenticated: true}), do: [user: insert(:internal_user)]
  def handle_user_tags(_), do: :ok
end
