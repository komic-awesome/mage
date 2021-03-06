defmodule Mage.GithubUsers.GithubUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "github_users" do
    field :avatar_url, :string
    field :bio, :string
    field :bio_html, :string
    field :company, :string
    field :company_html, :string
    field :database_id_in_github, :integer
    field :email, :string
    field :id_in_github, :string
    field :last_synced_at, :utc_datetime
    field :location, :string
    field :login, :string
    field :name, :string
    field :url, :string
    field :website_url, :string
    field :user_id, :id
    belongs_to :link, Mage.Links.Link
    field :avatar, :map

    timestamps()
  end

  @doc false
  def changeset(github_user, attrs) do
    github_user
    |> cast(attrs, [
      :id_in_github,
      :name,
      :login,
      :email,
      :location,
      :website_url,
      :url,
      :company,
      :company_html,
      :database_id_in_github,
      :avatar_url,
      :bio,
      :bio_html,
      :last_synced_at,
      :link_id,
      :avatar
    ])
    |> validate_required([
      :id_in_github
    ])
  end
end
