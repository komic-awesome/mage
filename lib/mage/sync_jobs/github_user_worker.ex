defmodule Mage.GithubUserWorker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:sync_github_user, api_result}, _from, state) do
    {
      :reply,
      Mage.GithubUsers.sync_github_user(api_result),
      state
    }
  end
end
