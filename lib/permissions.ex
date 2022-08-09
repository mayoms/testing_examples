defmodule TestingExamples.Permissions do
  @type p_resp :: {:ok, list(:atom)} | {:error, String.t()}

  @callback get_user_permissions(user_id :: integer()) :: p_resp()
  def get_user_permissions(_user_id) do
    {:ok, [:permission_a, :permission_b]}
  end

  @callback get_user_account_permissions(user_id :: integer(), account_id :: integer()) ::
              p_resp()
  def get_user_account_permissions(_user_id, _account_id) do
    {:ok, []}
  end
end
