defmodule Models do
  import ModelTypes

  def models do
    [
      { "Cat", "cats", [
          string("name"),
          integer("age"),
      ]},
      { "Rate", "rates", [
          string("agender"),
          decimal("height"),
      ]}
    ]
  end

  def connects do
    [
      {"Cat", "Rate"}
    ]
  end
end
