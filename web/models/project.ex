defmodule Dashex.Project do
  use Dashex.Web, :model

  schema "projects" do
    field :name, :string
    field :homepage, :string
    has_many :badges, Dashex.Badge, preload: true

    timestamps
  end

  @required_fields ~w(name homepage)
  @optional_fields ~w()

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
