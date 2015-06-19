defmodule Dashex.Repo.Migrations.CreateBadge do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add :name, :string
      add :image_url, :string
      add :project_id, references(:projects)

      timestamps
    end

  end
end
