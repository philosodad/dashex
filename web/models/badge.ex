defmodule Dashex.Badge do
  use Dashex.Web, :model
  require HTTPotion
  require IEx

  schema "badges" do
    field :name, :string
    field :image_url, :string
    field :service_link, :string

    belongs_to :project, Dashex.Project
    timestamps
  end

  @required_fields ~w(name image_url)
  @optional_fields ~w(service_link)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def process_readme(uri) do
    badgeline = ~r/\[\!\[.*\]\(https:\/\/.*\)\]\(https/
    splitline = ~r/\[\!\[(?<name>[\w\s]+)\]\((?<image_url>.+)\)\]\((?<service_link>.+)\)/

    badge_array = HTTPotion.get(uri).body |>
      String.split("\n") |>
      Enum.filter(fn(s) -> Regex.match?(badgeline, s) end ) |>
      Enum.map(fn(s) -> Regex.named_captures(splitline, s) end )
  end

end
