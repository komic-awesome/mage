defmodule MageWeb.SyncJobLive.Components do
  use Phoenix.Component

  def user_card(assigns) do
    ~H"""
    <div class="user-card">
      <div class="user-card__header">
        <a target="_blank" href={@user.url}>
          <div class="user-info">
            <div class="user-info__avatar">
              <img src={"/uploads/avatars/#{@user.avatar["key"]}"}>
            </div>
            <div class="user-info__content">
              <p class="text-gray-900 dark:text-gray-100 text-base truncate max-w-full leading-6  font-semibold transition-colors">
                <%= @user.name %>
                <span>（@<%= @user.login%>）</span>
              </p>
            </div>
          </div>
        </a>
      </div>

      <div class="block w-full"><div class="-mx-4 sm:-mx-6"><div class="w-full my-4 mx-auto border-t border-gray-100 dark:border-gray-900" style="max-width: 100%;"></div></div></div>
      <div class="user-card__body">
        <a target="_blank" href={@user.link.url}>
          <div class="link">
            <%= unless is_nil(@user.link.site.icon) do %>
            <div class="link__icon">
              <img src={"/uploads/icons/#{@user.link.site.icon["key"]}"}>
            </div>
            <% end %>
            <div class="link__content">
              <p class=" text-gray-900 dark:text-gray-100 text-base truncate max-w-full leading-6  font-semibold transition-colors"><%= @user.link.title%></p>
                          <div class="flex flex-wrap max-w-full gap-1  items-center justify-center  flex-nowrap overflow-hidden">
                <p class="text-gray-500 text-sm truncate max-w-full leading-5
                "><%= @user.link.url%></p>
                </div>
            </div>
          </div>
        </a>
      </div>

      <div class="user-card__actions">
        <%= if @user.link.rss_feed do%>
          <a target="_blank" href={@user.link.rss_feed.feed_url}>
            <img width="16" src="/images/icons/rss.svg">
            <%= @user.link.rss_feed.first_entity_title%>
          </a>
        <% end%>
      </div>
    </div>
    """
  end
end
