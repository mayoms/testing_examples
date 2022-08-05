defmodule DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Query
      import DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Shared.ReadWriteRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Shared.ReadWriteRepo, {:shared, self()})
    end

    :ok
  end
end
