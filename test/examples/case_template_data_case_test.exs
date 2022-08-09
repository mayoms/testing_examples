defmodule TestingExamples.DataCaseTest do
  use DataCase, async: true

  setup do
    # no need to clean up/tear down data, BaseCase.setup_repo_sandbox/1
    # ensures the DB is always clean for every test
    assert [] = Repo.all(User)
  end

  test "has ecto stuff" do
    insert_list(10, :user)
    insert_list(5, :user, is_internal?: true)

    query = from(u in User, where: [is_internal?: true])

    assert Repo.aggregate(query, :count) == 5
  end
end
