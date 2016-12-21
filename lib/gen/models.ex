defmodule Models do
  use ModelType
  use Relation

  def models, do: [
    {"Dog", "dogs", ["name:string"]},
    {"Pig", "pigs", ["name:string"]},
    {"Person", "people", ["name:string"]},
    {"Cat", "cats", ["name:string"]},
    {"Cow", "cows", ["name:string"]}
  ]

  def connects, do: [
    {"User", "Profile"}
  ]

  def relations, do: [
    {"Dog", :has_many, "Cat"},
    {"Pig", :has_one, "Cat"},
    {"Person", :many_to_many, "Cat"},
    {"Cat", :has_one, "Cow"},
  ]
end
