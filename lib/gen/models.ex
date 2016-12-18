defmodule Models do
  use ModelType

  def models do
    [
      {"User", "users", [string("name")]},
      {"Profile", "profiles", [string("name")]},
    ]
  end

  def connects do
    [{"User", "Profile"}]
  end
end
