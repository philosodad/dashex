defmodule Dashex.ProjectController do
  use Dashex.Web, :controller
  require IEx

  alias Dashex.Project

  plug :scrub_params, "project" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    query = from p in Project, preload: :badges
    projects = Repo.all(query)
    render(conn, "index.html", projects: projects)
  end

  def new(conn, _params) do
    changeset = Project.changeset(%Project{})
    render(conn, "new.html", changeset: changeset)
  end

  def new_from_readme(conn, _params) do
    render(conn, "new_from_readme.html")
  end


  def create_from_readme(conn, %{"project" => project_params}) do
    changeset = Project.changeset(%Project{}, Map.drop(project_params, ["readme"]))
    if changeset.valid? do
      project_id = Repo.insert(changeset) |> Map.get(:id)
      badgelist = Dashex.Badge.process_readme(project_params["readme"])
      project = Repo.get(Project, project_id)
      Enum.map(badgelist, fn(b) -> build(project, :badges, b ) end ) |>
      Enum.zip(badgelist) |>
      Enum.map(fn(b) -> Dashex.Badge.changeset(elem(b,0), elem(b,1)) end ) |>
      Enum.each(fn(change) -> if change.valid?, do: Repo.insert(change) end)
    else
      render(conn, "new_from_readme.html")
    end
    index(conn, project_params)
  end

  def create(conn, %{"project" => project_params}) do
    changeset = Project.changeset(%Project{}, project_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Project created successfully.")
      |> redirect(to: project_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Repo.get(Project, id)
    badges = Repo.all assoc(project, :badges)
    render(conn, "show.html", project: project, badges: badges)
  end

  def edit(conn, %{"id" => id}) do
    project = Repo.get(Project, id)
    changeset = Project.changeset(project)
    render(conn, "edit.html", project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Repo.get(Project, id)
    changeset = Project.changeset(project, project_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Project updated successfully.")
      |> redirect(to: project_path(conn, :index))
    else
      render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.get(Project, id)
    Repo.delete(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: project_path(conn, :index))
  end
end
