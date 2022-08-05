defmodule TestingExamples.Users.Account do
  alias TestingExamples.Users.User
  use Ecto.Schema

  schema "accounts" do
    field :name, :string

    has_many :users, User
  end
end
