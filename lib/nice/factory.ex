defmodule Nice.Factory do
  use ExMachina.Ecto, repo: Nice.Repo
  alias Nice.Cat

  def cat_factory do
    %Cat{
      name: sequence(:name, &("Some Cat - #{&1}"))
    }
  end
end
