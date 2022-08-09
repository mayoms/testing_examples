defmodule TestingExamples.Users do
  alias TestingExamples.{Repo, Users.User}
  alias TestingExamples.Permissions
  require Logger

  def find(user_id) do
    Repo.get(User, user_id)
  end

  # suffix default arg: avoids confugiration, multiple default opts are not supported,
  # changing function signature requires updating all call sites, requires 'dep-drilling'
  def has_permission_suffix_injection?(user, required_permission, p_mod \\ Permissions),
    do: check_permission(p_mod, user, required_permission)

  # prefix default arg: avoids configuration, supports multiple default opts and changing
  # the function signature. requires 'dep-drilling'
  def has_permission_prefix_injection?(p_mod \\ Permissions, user, required_permission),
    do: check_permission(p_mod, user, required_permission)

  # default opts: avoids configuration, supports multiple default opts and changing
  # the function signature. requires 'dep-drilling'
  def has_permission_default_opts?(user, required_permission, opts \\ []) do
    opts = Keyword.merge([p_mod: Permissions], opts)

    check_permission(opts[:p_mod], user, required_permission)
  end

  # use compile_env/3 as opposed to get/fetch_env -- will throw an error if the
  # config changes post-compile
  @permission_client Application.compile_env(:testing_examples, :p_mod, Permissions)

  # test confg, with default in module -> config in test.exs only, default
  # is explicit in module, no impact to function signature does not require 'dep-drilling'
  def has_permission_compile_env(user, required_permission),
    do: check_permission(@permission_client, user, required_permission)

  defp check_permission(mod, user, permission) do
    case mod.get_user_permissions(user.id) do
      {:ok, permissions} ->
        Enum.member?(permissions, permission)

      {:error, msg} ->
        Logger.error(msg)
        false
    end
  end
end
