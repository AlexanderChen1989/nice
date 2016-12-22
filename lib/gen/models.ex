defmodule Models do
  use ModelType
  use Relation

  def models, do: [
    {"Dog", "dogs", ["name:string"]},
    {"Pig", "pigs", ["name:string"]},
    {"Cow", "cows", ["name:string"]},
    {"Cat", "cats", ["name:string"]},
  ]

  def connects, do: [
    {"Dog",  "Cat"}, # one to one
    {"Pig",  "Cat"}, # one to many 
    {"Cow",  "Cat"}, # many to many
  ]

  def relations, do: [
    {"Dog", :many_to_many, "Cat"},
    {"Pig", :many_to_many, "Cat"},
    {"Cow", :many_to_many, "Cat"},
  ]
end
