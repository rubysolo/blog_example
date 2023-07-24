defmodule Blergh.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blergh.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title",
        published_on: Date.utc_today()
      })
      |> Blergh.Blog.create_post()

    post
  end
end
