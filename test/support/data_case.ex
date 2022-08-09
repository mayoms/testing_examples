defmodule DataCase do
  use ExUnit.CaseTemplate
  import BaseCase

  using do
    quote do
      import Ecto
      import Ecto.Query
      import Mox
      import DataCase
      import Factory

      alias TestingExamples.Users.User
      alias TestingExamples.Repo
    end
  end

  setup [
    :setup_repo_sandbox,
    :handle_user_tags
  ]
end
