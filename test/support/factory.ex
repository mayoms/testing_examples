defmodule Factory do
  use ExMachina.Ecto, repo: TestingExamples.Repo

  alias TestingExamples.Repo
  alias TestingExamples.Users.{User, Account}

  def user_factory do
    %User{
      first_name: "first name",
      last_name: "last_name",
      email: sequence(:internal_email, &"email#{&1}@example.com"),
      role: "user",
      is_verified?: true
    }
  end

  def internal_user_factory do
    pd_account = build(:pd_account)

    build(:user,
      is_internal?: true,
      is_verified?: true,
      email: sequence(:internal_email, &"email#{&1}@pagerduty.example.com"),
      role: "user",
      account: pd_account
    )
  end

  def account_factory do
    %Account{name: sequence("account_name")}
  end

  def pd_account_factory do
    case Repo.get_by(Account, name: "PagerDuty") do
      nil -> insert(:account, name: "PagerDuty")
      account -> account
    end
  end
end
