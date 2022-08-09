defmodule TestingExamples.ConnCaseTest do
  use ConnCase, async: true

  describe "without tags" do
    test "user not in context", context do
      assert is_nil(get_in(context, [:user]))
    end

    test "conn is not authenticated", %{conn: conn} do
      assert %{status: 403, resp_body: "unauthorized"} = get(conn, "/any_route")
    end
  end

  describe "with :authenticated tag" do
    @describetag :authenticated

    test "user is in context and id in request header", %{user: user, conn: conn} do
      assert %TestingExamples.Users.User{is_internal?: false} = user
      assert [to_string(user.id)] == get_req_header(conn, "x-user-id")
    end

    test "user requests are successful", %{conn: conn} do
      assert %{status: 200} = get(conn, "/me")
    end

    @tag user_permissions: [:view_users]
    test "user permission stubs", %{conn: conn} do
      user = insert(:user, first_name: "different", last_name: "user")

      assert %{status: 200, resp_body: body} = get(conn, "/users/#{user.id}")

      assert Jason.encode!(user) == body
    end
  end

  describe "with :internal_authenticated tag" do
    @describetag :internal_authenticated

    test "user is in context and id in request header", %{user: user, conn: conn} do
      assert %TestingExamples.Users.User{is_internal?: true} = user
      assert [to_string(user.id)] == get_req_header(conn, "x-user-id")
    end

    test "user requests are successful", %{conn: conn} do
      assert %{status: 200} = get(conn, "/me")
    end

    @tag user_permissions: []
    test "user without permission stubs", %{conn: conn} do
      user = insert(:user, first_name: "different", last_name: "user")

      assert %{status: 403, resp_body: "unauthorized"} = get(conn, "/users/#{user.id}")
    end

    @tag user_permissions: [:view_users]
    test "user with permission stubs", %{conn: conn} do
      user = insert(:user, first_name: "different", last_name: "user")

      assert %{status: 200} = get(conn, "/users/#{user.id}")
    end

    @tag internal_authenticated: false
    @tag user_permissions: [:view_users]
    test "unauthenticated user with permission stubs", %{conn: conn} do
      user = insert(:user, first_name: "different", last_name: "user")

      assert %{status: 403} = get(conn, "/users/#{user.id}")
    end
  end
end
