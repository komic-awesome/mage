defmodule Mage.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    has_one :user_identity, Mage.UserIdentities.UserIdentity

    many_to_many :followers, Mage.GithubUsers.GithubUser,
      join_through: "user_follower",
      on_replace: :delete

    many_to_many :followings, Mage.GithubUsers.GithubUser,
      join_through: "user_following",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :followers, :followings])
    |> validate_required([:email])
  end
end
