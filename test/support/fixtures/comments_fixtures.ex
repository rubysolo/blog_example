defmodule Blergh.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blergh.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> Blergh.Comments.create_comment()

    comment
  end
end
