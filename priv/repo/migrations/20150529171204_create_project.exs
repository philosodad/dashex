defmodule Dashex.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :homepage, :string

      timestamps
    end

  end
end
