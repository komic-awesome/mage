defmodule Mage.Repo do
  use Ecto.Repo,
    otp_app: :mage,
    adapter: Ecto.Adapters.MyXQL
end
