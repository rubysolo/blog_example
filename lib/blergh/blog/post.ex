defmodule Blergh.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :title, :string
    field :published_on, :date

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published_on])
    |> validate_required([:title, :content, :published_on])
    |> validate_date_not_past(:published_on)
  end

  defp validate_date_not_past(changeset, field_name) do
    date = get_field(changeset, field_name) || Date.utc_today()

    case Date.compare(date, Date.utc_today()) do
      :lt ->
        add_error(changeset, field_name, "must not be in the past")

      _ ->
        changeset
    end
  end
end
