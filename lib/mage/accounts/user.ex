defmodule Mage.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    has_one :user_identity, Mage.UserIdentities.UserIdentity

    many_to_many :followers, Mage.GithubUsers.GithubUser, join_through: "user_follower"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :followers])
    |> validate_required([:email])
  end
end
