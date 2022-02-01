defmodule Mage.Github.Followings do
  @query """
    query ($limit: Int = 50, $after: String = null) {
      viewer {
        following(first: $limit, after: $after) {
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

  @followings_limit 20

  def chunk_user_followings(access_token, max_page \\ 40) do
    chunk_stream =
      Stream.unfold(
        {nil, 0},
        fn
          :stop ->
            {[], :stop}

          {end_cursor, current_page} ->
            current_page = current_page + 1

            {entries, end_cursor} = query_user_followings(access_token, end_cursor)

            cond do
              current_page >= max_page ->
                {[], :stop}

              end_cursor == :stop ->
                {[], :stop}

              true ->
                {entries, {end_cursor, current_page}}
            end
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

  def query_user_followings(access_token, end_cursor) do
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
               limit: @followings_limit,
               after: end_cursor
             },
             url: "https://api.github.com/graphql",
             headers: [authorization: "Bearer #{access_token}"]
           ) do
      {
        Enum.map(get_in(body, ["data", "viewer", "following", "edges"]), & &1["node"]),
        case get_in(body, ["data", "viewer", "following", "pageInfo"]) do
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
