defmodule Mage.UserIdentities do
  alias Mage.UserIdentities.UserIdentity
  alias Mage.Repo

  def fetch_access_token(nil), do: {:error, "user_id 为空"}

  def fetch_access_token(user_id) do
    case Repo.get_by(UserIdentity, %{user_id: user_id, provider: "github"}) do
      %UserIdentity{} = user_identity ->
        case user_identity do
          %{access_token: access_token} when is_binary(access_token) ->
            {:ok, access_token}

          _ ->
            {:error, "access_token 获取错误"}
        end

      _ ->
        {:error, "UserIdentity 获取失败"}
    end
  end
end
