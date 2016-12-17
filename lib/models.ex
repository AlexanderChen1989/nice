defmodule Models do
  import ModelTypes

  def models do
    [
      { "Cat", "cats", [
          string("name"),
          integer("age"),
      ]},
      { "Rat", "rats", [
          string("name"),
          string("agender"),
          decimal("height"),
      ]}
    ]
  end

  def connects do
    [
      {"Cat", "Rat"}
    ]
  end
end
