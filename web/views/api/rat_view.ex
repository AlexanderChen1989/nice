defmodule Nice.API.RatView do
  use Nice.Web, :view

  def render("index.json", %{rats: rats}) do
    %{data: render_many(rats, Nice.API.RatView, "rat.json")}
  end

  def render("show.json", %{rat: rat}) do
    %{data: render_one(rat, Nice.API.RatView, "rat.json")}
  end

  def render("rat.json", %{rat: rat}) do
    %{id: rat.id,
      name: rat.name,
      agender: rat.agender,
      height: rat.height}
  end
end
