defmodule TestingExamples.Users.User do
  alias TestingExamples.Users.Account
  use Ecto.Schema

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :is_internal?, :boolean, default: false
    field :is_verified?, :boolean, default: false
    field :role, :string

    belongs_to :account, Account
  end
end
