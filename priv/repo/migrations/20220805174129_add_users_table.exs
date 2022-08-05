defmodule TestingExamples.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :is_internal?, :boolean
      add :is_verified?, :boolean
      add :role, :string
    end
  end
end
