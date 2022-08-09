defmodule TestingExamples.Permissions do
  alias TestingExamples.Permissions.Server

  @type p_resp :: {:ok, list(:atom)} | {:error, String.t()}

  @callback get_user_permissions(user_id :: integer()) :: p_resp()
  def get_user_permissions(user_id) do
    Server.get_user_permissions(user_id)
  end
end
