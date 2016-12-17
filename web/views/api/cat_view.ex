defmodule Nice.API.CatView do
  use Nice.Web, :view

  def render("index.json", %{cats: cats}) do
    %{data: render_many(cats, Nice.API.CatView, "cat.json")}
  end

  def render("show.json", %{cat: cat}) do
    %{data: render_one(cat, Nice.API.CatView, "cat.json")}
  end

  def render("cat.json", %{cat: cat}) do
    %{id: cat.id,
      name: cat.name,
      age: cat.age}
  end
end
