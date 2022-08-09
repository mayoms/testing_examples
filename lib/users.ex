defmodule TestingExamples.Users do
  alias TestingExamples.{Repo, Users.User}
  alias TestingExamples.Permissions
  require Logger

  @permission_client Application.compile_env(:testing_examples, :p_mod, Permissions)

  def find(user_id) do
    Repo.get(User, user_id)
  end

  # suffix dependency injection: avoid
  def has_permission_suffix_injection?(user, required_permission, p_mod \\ Permissions),
    do: check_permission(p_mod, user, required_permission)

  # prefix injection -> more explicit in tests
  def has_permission_prefix_injection?(p_mod \\ Permissions, user, required_permission),
    do: check_permission(p_mod, user, required_permission)

  # default opts -> similar to prefix, more verbose?
  def has_permission_default_opts(user, required_permission, opts \\ []) do
    opts = Keyword.merge([p_mod: Permissions], opts)

    check_permission(user, required_permission, opts[:p_mod])
  end

  # test config injection -> less explicit, less toil
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
