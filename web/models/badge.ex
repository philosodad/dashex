defmodule Dashex.Badge do
  use Dashex.Web, :model

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
end
