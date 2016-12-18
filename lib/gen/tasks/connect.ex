defmodule Mix.Tasks.Gen.Connect do
  use Mix.Task

  @shortdoc "Generates controller, model and views for an HTML based resource"

  @moduledoc """
  Generates a Phoenix resource.

      mix phoenix.gen.html User users name:string age:integer

  The first argument is the module name followed by
  its plural name (used for resources and schema).

  The generated resource will contain:

    * a schema in web/models
    * a view in web/views
    * a controller in web/controllers
    * a migration file for the repository
    * default CRUD templates in web/templates
    * test files for generated model and controller

  The generated model can be skipped with `--no-model`.
  Read the documentation for `phoenix.gen.model` for more
  information on attributes and namespaced resources.
  """
  def run(args) do
    switches = [binary_id: :boolean, model: :boolean]

    {opts, parsed, _} = OptionParser.parse(args, switches: switches)
    [singular, plural | attrs] = validate_args!(parsed)

    default_opts = Application.get_env(:phoenix, :generators, [])
    opts = Keyword.merge(default_opts, opts)

    attrs   = Mix.Phoenix.attrs(attrs)
    binding = Mix.Phoenix.inflect(singular)
    path    = binding[:path]
    route   = String.split(path, "/") |> Enum.drop(-1) |> Kernel.++([plural]) |> Enum.join("/")
    binding = binding ++ [plural: plural, route: route, attrs: attrs,
                          sample_id: sample_id(opts),
                          inputs: inputs(attrs), params: Mix.Phoenix.params(attrs),
                          template_singular: String.replace(binding[:singular], "_", " "),
                          template_plural: String.replace(plural, "_", " ")]

    Mix.Phoenix.check_module_name_availability!(binding[:module] <> "ConnectController")
    Mix.Phoenix.check_module_name_availability!(binding[:module] <> "ConnectView")

    [from, to] =
      Keyword.get(binding, :alias)
      |> String.split("To")

    [from_singular, to_singular] =
      Keyword.get(binding, :singular)
      |> String.split("_to_")

    [from_plural, to_plural] =
      [from_singular, to_singular]
      |> Enum.map(& &1 <> "s")

    binding =
      binding ++
      [from: from, to: to] ++
      [from_singular: from_singular, to_singular: to_singular] ++
      [from_plural: from_plural, to_plural: to_plural]

    Mix.Phoenix.copy_from paths(), "priv/templates/gen.html", "", binding, [
      {:eex, "connect_controller.ex.t",       "web/controllers/#{path}_connect_controller.ex"},
      {:eex, "connect.html.eex.t",      "web/templates/#{path}_connect/connect.html.eex"},
      {:eex, "connect_view.ex.t",             "web/views/#{path}_connect_view.ex"},
    ]
  end

  defp sample_id(opts) do
    if Keyword.get(opts, :binary_id, false) do
      Keyword.get(opts, :sample_binary_id, "11111111-1111-1111-1111-111111111111")
    else
      -1
    end
  end

  defp validate_args!([_, plural | _] = args) do
    cond do
      String.contains?(plural, ":") ->
        raise_with_help()
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "Expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
  end

  defp validate_args!(_) do
    raise_with_help()
  end

  @spec raise_with_help() :: no_return()
  defp raise_with_help do
    Mix.raise """
    mix phoenix.gen.html expects both singular and plural names
    of the generated resource followed by any number of attributes:

        mix phoenix.gen.html User users name:string
    """
  end

  defp inputs(attrs) do
    Enum.map attrs, fn
      {_, {:array, _}} ->
        {nil, nil, nil}
      {_, {:references, _}} ->
        {nil, nil, nil}
      {key, :integer}    ->
        {label(key), ~s(<%= number_input f, #{inspect(key)}, class: "form-control" %>), error(key)}
      {key, :float}      ->
        {label(key), ~s(<%= number_input f, #{inspect(key)}, step: "any", class: "form-control" %>), error(key)}
      {key, :decimal}    ->
        {label(key), ~s(<%= number_input f, #{inspect(key)}, step: "any", class: "form-control" %>), error(key)}
      {key, :boolean}    ->
        {label(key), ~s(<%= checkbox f, #{inspect(key)}, class: "form-control" %>), error(key)}
      {key, :text}       ->
        {label(key), ~s(<%= textarea f, #{inspect(key)}, class: "form-control" %>), error(key)}
      {key, :date}       ->
        {label(key), ~s(<%= date_select f, #{inspect(key)}, class: "form-control" %>), error(key)}
      {key, :time}       ->
        {label(key), ~s(<%= time_select f, #{inspect(key)}, class: "form-control" %>), error(key)}
      {key, :datetime}   ->
        {label(key), ~s(<%= datetime_select f, #{inspect(key)}, class: "form-control" %>), error(key)}
      {key, _}           ->
        {label(key), ~s(<%= text_input f, #{inspect(key)}, class: "form-control" %>), error(key)}
    end
  end

  defp label(key) do
    ~s(<%= label f, #{inspect(key)}, class: "control-label" %>)
  end

  defp error(field) do
    ~s(<%= error_tag f, #{inspect(field)} %>)
  end

  defp paths do
    [".", :phoenix]
  end
end
