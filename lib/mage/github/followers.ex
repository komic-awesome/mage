defmodule Mage.Github.Followers do
  @query """
    query ($limit: Int = 20, $after: String = null) {
      viewer {
        followers(first: $limit, after: $after) {
          edges {
            node {
              id
              name
              login
              email
              location
              websiteUrl
              company
              companyHTML
              databaseId
              avatarUrl
              bio
              bioHTML
              url
            }
          }
          pageInfo {
            endCursor
            startCursor
            hasNextPage
          }
          totalCount
        }
      }
    }
  """

  @followers_limit 20

  def chunk_user_followers(access_token) do
    chunk_stream =
      Stream.unfold(
        nil,
        fn
          :stop ->
            {[], :stop}

          end_cursor ->
            {entries, end_cursor} = query_user_followers(access_token, end_cursor)

            {entries, end_cursor}
        end
      )

    Stream.take_while(
      chunk_stream,
      fn
        [] -> false
        _ -> true
      end
    )
  end

  def query_user_followers(access_token, end_cursor) do
    with {
           :ok,
           %Neuron.Response{
             body: body,
             headers: _headers,
             status_code: 200
           }
         } <-
           Neuron.query(
             @query,
             %{
               limit: @followers_limit,
               after: end_cursor
             },
             url: "https://api.github.com/graphql",
             headers: [authorization: "Bearer #{access_token}"]
           ) do
      {
        Enum.map(get_in(body, ["data", "viewer", "followers", "edges"]), & &1["node"]),
        case get_in(body, ["data", "viewer", "followers", "pageInfo"]) do
          %{"hasNextPage" => false} ->
            :stop

          %{"endCursor" => end_cursor} ->
            end_cursor

          _ ->
            :stop
        end
      }
    end
  end
end
