defmodule Nice.Schema.Types do
  use Absinthe.Schema.Notation

  @desc "An item"
  object :item do
    field :id, :id
    field :name, :string
  end

	scalar :time, description: "ISOz time" do
    parse &Timex.parse(&1.value, "{ISOz}")
    serialize &Timex.format!(&1, "{ISOz}")
  end
end
