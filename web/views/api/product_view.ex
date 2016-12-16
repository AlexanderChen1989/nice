defmodule Nice.API.ProductView do
  use Nice.Web, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, Nice.API.ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, Nice.API.ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      category_id: product.category_id,
      name: product.name,
      description: product.description,
      cover: product.cover,
      samples: product.samples,
      summary: product.summary,
      polish_print_price: product.polish_print_price,
      print_price: product.print_price,
      display_type: product.display_type}
  end
end
