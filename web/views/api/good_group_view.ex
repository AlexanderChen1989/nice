defmodule Nice.API.GoodGroupView do
  use Nice.Web, :view

  def render("index.json", %{good_groups: good_groups}) do
    %{data: render_many(good_groups, Nice.API.GoodGroupView, "good_group.json")}
  end

  def render("show.json", %{good_group: good_group}) do
    %{data: render_one(good_group, Nice.API.GoodGroupView, "good_group.json")}
  end

  def render("good_group.json", %{good_group: good_group}) do
    %{id: good_group.id,
      product_id: good_group.product_id,
      name: good_group.name,
      max_selection: good_group.max_selection}
  end
end
