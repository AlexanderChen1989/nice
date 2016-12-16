defmodule Nice.API.CategoryView do
  use Nice.Web, :view

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, Nice.API.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, Nice.API.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id,
      name: category.name}
  end
end
