defmodule Models do
  import ModelTypes

  def models do
    [
      {"User", "users", [string("name")]},
      {"Profile", "profiles", [string("name")]},
    ]
  end

  def connects do
    [{"User", "Profile"}]
  end

  def connect_models() do
    ms = Enum.map(models, fn {m, _, _} -> m end)

    connects
    |> Enum.map(fn {from, to} ->
        if (not from in ms) || (not to in ms) do
          raise "#{from} or #{to} should in #{ms |> inspect}"
        end

        from_lower = Macro.underscore(from)
        to_lower = Macro.underscore(to)

        model = "#{from}To#{to}"
        table = "#{from_lower}_to_#{to_lower}s"
        fields = ["#{from_lower}_id:integer", "#{to_lower}_id:integer"]

        {model, table, fields}
      end)
  end
end


defmodule ModelsX do
  import ModelTypes

  def models do
    [
      {"User", "users", [
        string("name"),
        string("wechat"),
        string("phone"),
      ]},
      {"Category", "categories", [
          string("name"),
      ]},
      {"Product", "products", [
          string("name"),
          string("description"),
          string("cover"),
          string("summary"),
          decimal("polish_print_price"),
          decimal("print_price"),
          string("display_type"),
          #Samples          []Picture
          #GoodGroups       []GoodGroup
      ]},
      {"GoodGroup", "good_groups", [
        string("name"),
        integer("max_selection"),
        #Goods        []Good
      ]},
      { "Good", "goods", [
        string("name"),
        string("description"),
        string("color"),
        string("specification"),
        decimal("price"),
        decimal("discount"),
      ]},
      {"Order", "orders", [
        string("name"),
        string("status"),
        string("system_status"),
        string("paid_status"),
        decimal("price"),
        string("trade_provider"),
        string("trade_raw"),
        date("book_date"),
        time("book_time"),
        #StoreID       Store
        #UserID       User
        #ProductID    Product
      ]},
      {"Store", "stores", [
        string("name"),
        string("country"),
        string("province"),
        string("city"),
        string("address"),
        string("map_location"),
        string("phone"),
        time("open_at"),
        time("close_at"),
        integer("time_cost"),

      	# Photo       Picture
      	# Services    []StoreService
      ]},
      {"StoreService", "store_services", [
        string("name"),
        string("icon"),
        string("description"),
      ]},
      {"Picture", "pictures", [
        string("name"),
        string("description"),
        boolean("is_public"),
      ]}
    ]
  end

  def connects do
    [
      {"Category", "Product"},
      {"Product", "GoodGroup"},
      {"Product", "Picture"},
      {"GoodGroup", "Good"},
      {"Order", "User"},
      {"Order", "Store"},
      {"Order", "Product"},
      {"Store", "Picture"},
      {"Store", "StoreService"},
    ]
  end

  def connect_models() do
    ms = Enum.map(models, fn {m, _, _} -> m end)

    connects
    |> Enum.map(fn {from, to} ->
        if (not from in ms) || (not to in ms) do
          raise "#{from} or #{to} should in #{ms |> inspect}"
        end

        from_lower = Macro.underscore(from)
        to_lower = Macro.underscore(to)

        model = "#{from}To#{to}"
        table = "#{from_lower}_to_#{to_lower}s"
        fields = ["#{from_lower}_id:integer", "#{to_lower}_id:integer"]

        {model, table, fields}
      end)
  end
end
