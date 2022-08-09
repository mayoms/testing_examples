defmodule TestingExamples.DependencyInjectionTest do
  use DataCase
  import ExUnit.CaptureLog
  alias TestingExamples.Permissions

  @moduletag :authenticated

  setup %{user: %{id: user_id}} do
    base_permissions = [:list, :of, :permissions]
    stub(PermissionMock, :get_user_permissions, fn ^user_id -> {:ok, base_permissions} end)

    :ok
  end

  describe "has_permission_suffix_injection?/1" do
    test "returns permissions", %{user: user} do
      assert Users.has_permission_suffix_injection?(user, :list, PermissionMock)
    end

    defmodule WithSuffix do
      def without_drilling(user) do
        Users.has_permission_suffix_injection?(user, :list)
      end

      # now has the same issue with fn signature
      def with_drilling(user, p_mod \\ Permissions) do
        Users.has_permission_suffix_injection?(user, :list, p_mod)
      end
    end

    test "parent requires 'dep-drilling", %{user: user} do
      assert capture_log([level: :error], fn -> WithSuffix.without_drilling(user) end) =~
               "user not found"

      assert WithSuffix.with_drilling(user, PermissionMock)
    end
  end

  describe "has_permission_prefix_injection?/1" do
    test "returns permissions", %{user: user} do
      assert Users.has_permission_prefix_injection?(PermissionMock, user, :list)
    end

    defmodule WithPrefix do
      def without_drilling(user) do
        Users.has_permission_prefix_injection?(user, :list)
      end

      def with_drilling(p_mod \\ Permissions, user) do
        Users.has_permission_suffix_injection?(user, :list, p_mod)
      end
    end

    test "parent requires 'dep-drilling", %{user: user} do
      assert capture_log([level: :error], fn -> WithPrefix.without_drilling(user) end) =~
               "user not found"

      assert WithPrefix.with_drilling(PermissionMock, user)
    end
  end

  describe "has_permission_opt_injection?/1" do
    test "returns permissions", %{user: user} do
      assert Users.has_permission_default_opts?(user, :list, p_mod: PermissionMock)
    end

    defmodule WithDefaultOpts do
      def without_drilling(user) do
        Users.has_permission_default_opts?(user, :list)
      end

      def with_drilling(user, opts \\ []) do
        opts = Keyword.merge([p_mod: Permissions], opts)

        Users.has_permission_default_opts?(user, :list, p_mod: opts[:p_mod])
      end
    end

    test "parent requires 'dep-drilling", %{user: user} do
      assert capture_log([level: :error], fn -> WithDefaultOpts.without_drilling(user) end) =~
               "user not found"

      assert WithDefaultOpts.with_drilling(user, p_mod: PermissionMock)
    end
  end
end
