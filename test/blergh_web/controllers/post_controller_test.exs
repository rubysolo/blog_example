defmodule BlerghWeb.PostControllerTest do
  use BlerghWeb.ConnCase

  import Blergh.BlogFixtures

  @create_attrs %{content: "some content", title: "some title", published_on: Date.utc_today()}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "Listing Posts"
    end

    test "posts are sorted newest to oldest", %{conn: conn} do
      [
        %{title: "middle", published_on: ~D[3023-06-01]},
        %{title: "newest", published_on: ~D[3023-07-01]},
        %{title: "oldest", published_on: ~D[3023-05-01]},
      ]
      |> Enum.each(&post_fixture/1)

      conn = get(conn, ~p"/posts")
      html = html_response(conn, 200)

      {:ok, document} = Floki.parse_document(html)
      titles =
        document
        |> Floki.find("td:first-child")
        |> Enum.map(&Floki.text/1)
        |> Enum.map(&String.trim/1)

      assert titles == ~w[newest middle oldest]
    end

    test "invisible posts are not shown", %{conn: conn} do
      [
        %{title: "visible"},
        %{title: "invisible", visible: false}
      ]
      |> Enum.each(&post_fixture/1)

      conn = get(conn, ~p"/posts")
      html = html_response(conn, 200)

      {:ok, document} = Floki.parse_document(html)
      titles =
        document
        |> Floki.find("td:first-child")
        |> Enum.map(&Floki.text/1)
        |> Enum.map(&String.trim/1)

      assert titles == ~w[visible]
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/posts/new")
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/posts", post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ "Post #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/posts", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = get(conn, ~p"/posts/#{post}/edit")
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = put(conn, ~p"/posts/#{post}", post: @update_attrs)
      assert redirected_to(conn) == ~p"/posts/#{post}"

      conn = get(conn, ~p"/posts/#{post}")
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, ~p"/posts/#{post}", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, ~p"/posts/#{post}")
      assert redirected_to(conn) == ~p"/posts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/posts/#{post}")
      end
    end
  end

  defp create_post(_) do
    post = post_fixture()
    %{post: post}
  end
end
