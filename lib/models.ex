defmodule Models do
  import ModelTypes

  def models do
    [
      { "User", "users", [
          string("name"),
          integer("age"),
      ]},
      { "Profile", "profiles", [
          string("agender"),
          decimal("height"),
      ]}
    ]
  end

  def connects do
    [
      {"User", "Profile"}
    ]
  end
end
