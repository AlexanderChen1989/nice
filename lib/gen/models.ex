defmodule Models do
  use ModelType
  use Relation

  def models, do: [
    {"Dog", "dogs", ["name:string"]},
    {"Pig", "pigs", ["name:string"]},
    {"Owner", "owners", ["name:string"]},
    {"Cat", "cats", ["name:string"]},
    {"Cow", "cows", ["name:string"]}
  ]

  def connects, do: [
    {"User", "Profile"}
  ]

  def relations, do: [
    {"Dog", :has_many, "Cat"},
    {"Pig", :has_one, "Cat"},
    {"Owner", :many_to_many, "Cat"},
    {"Cat", :has_one, "Cow"},
    {"Pig", :many_to_many, "Cow"},
  ]
end
