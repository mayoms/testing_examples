defmodule TestingExamples.Repo.Migrations.AddAccounts do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add :name, :string
    end

    alter table("users") do
      add :account_id, references("accounts")
    end
  end
end
