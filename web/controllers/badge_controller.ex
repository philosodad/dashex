defmodule Dashex.BadgeController do
  use Dashex.Web, :controller
  require Logger
  require IEx
  alias Dashex.Badge

  plug :find_project
  plug :scrub_params, "badge" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    badges = Repo.all assoc(conn.assigns.project, :badges)
    render conn, badges: badges
  end

  def new(conn, _) do
    changeset = Badge.changeset(%Badge{})
    render conn, changeset: changeset
  end

  def create(conn, %{"badge" => badge_params}) do
    new_badge = build(conn.assigns.project, :badges)
    changeset = Badge.changeset(new_badge, badge_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Badge has been successfully created.")
      |> redirect(to: project_badge_path(conn, :index, conn.assigns.project))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    badge = Repo.get(Badge, id)
    changeset = Badge.changeset(badge)
    project = conn.assigns.project |>
              Repo.preload(:badges)
    render(conn, "edit.html", badge: badge, project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "badge" => badge_params}) do
    badge = Repo.get(Badge, id)
    changeset = Badge.changeset(badge, badge_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Badge updated successfully.")
      |> redirect(to: project_badge_path(conn, :index, conn.assigns.project))
    end
  end

  def delete(conn, %{"id" => id}) do
    badge = Repo.get(Badge, id)
    Repo.delete(badge)

    conn
    |> put_flash(:info, "Badge deleted successfully.")
    |> redirect(to: project_badge_path(conn, :index, conn.assigns.project))
  end

  defp find_project(conn, _) do
    Logger.debug "project id: #{conn.params["project_id"]}"
    project = Repo.get(Dashex.Project, conn.params["project_id"])
    assign(conn, :project, project)
  end
end
