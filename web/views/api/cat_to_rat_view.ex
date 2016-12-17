defmodule Nice.API.CatToRatView do
  use Nice.Web, :view

  def render("index.json", %{cat_to_rats: cat_to_rats}) do
    %{data: render_many(cat_to_rats, Nice.API.CatToRatView, "cat_to_rat.json")}
  end

  def render("show.json", %{cat_to_rat: cat_to_rat}) do
    %{data: render_one(cat_to_rat, Nice.API.CatToRatView, "cat_to_rat.json")}
  end

  def render("cat_to_rat.json", %{cat_to_rat: cat_to_rat}) do
    %{id: cat_to_rat.id,
      cat_id: cat_to_rat.cat_id,
      rat_id: cat_to_rat.rat_id}
  end
end
