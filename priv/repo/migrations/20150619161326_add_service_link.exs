defmodule Dashex.Repo.Migrations.AddServiceLink do
  use Ecto.Migration

  def change do
    alter table(:badges) do
      add :service_link, :string
    end
  end
end
