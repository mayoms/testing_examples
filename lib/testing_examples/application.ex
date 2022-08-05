defmodule TestingExamples.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {TestingExamples.Repo, []},
      {Plug.Cowboy, scheme: :http, plug: TestingExamples.Router, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: TestingExamples.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
