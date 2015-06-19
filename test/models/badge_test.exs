defmodule Dashex.BadgeTest do
  use Dashex.ModelCase

  alias Dashex.Badge

  @valid_attrs %{image_url: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Badge.changeset(%Badge{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Badge.changeset(%Badge{}, @invalid_attrs)
    refute changeset.valid?
  end
end
