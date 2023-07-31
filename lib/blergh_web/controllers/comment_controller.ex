defmodule BlerghWeb.CommentController do
  use BlerghWeb, :controller

  def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    case Blergh.Comments.create_comment(Map.put(comment_params, "post_id", post_id)) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Commented")
        |> redirect(to: ~p"/posts/#{comment.post_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
