defmodule ConnCase do
  use ExUnit.CaseTemplate
  alias TestingExamples.Router

  using do
    quote do
      use Plug.Test

      def get(path, params_or_body \\ nil), do: conn(:get, path, params_or_body) |> dispatch()

      def dispatch(conn), do: conn |> Router.call(Router.init([]))
    end
  end
end
