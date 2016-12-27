defmodule Mix.Tasks.Gen.Tasks.Query do
  def run(_) do

    Models.relations
    |> header
    |> IO.puts

    Models.relations
    |> body
    |> Enum.each(&IO.puts/1)

    footer
    |> IO.puts

  end

  def put(lst, item) do
    if item in lst do
      lst
    else
      [item | lst]
    end
  end

  def header(relations) do
    relations
    |> Enum.reduce([], fn
        {from, :many_to_many, to}, acc  ->
          acc
          |> put(from)
          |> put(to)
          |> put("#{from}To#{to}")

        _, acc -> acc
      end)
    |> case do
      list ->
         ~s/
defmodule #{base}.ConnectQuery do
  alias #{base}.{Repo, #{list |> Enum.join(", ") }}
  alias Ecto.Multi
  import Ecto.Query/
    end
  end

  def otp_app do
    Mix.Project.config |> Keyword.fetch!(:app)
  end


  def base do
    app = otp_app()

    case Application.get_env(app, :namespace, app) do
      ^app -> app |> to_string |> Phoenix.Naming.camelize
      mod  -> mod |> inspect
    end
  end

  def footer do
    ~s/
end
    /
  end

  def body(relations) do
    create_to_s(relations) ++
    create_from_s_to_to_s(relations) ++
    get_from_to_s(relations) ++
    query_funcs(relations)
  end

  defp create_to_s(relations) do
    relations =
      relations
      |> Enum.uniq_by(fn {from, _, to} -> {from, to} end)
      |> Enum.sort_by(fn {_, _, to} -> to end)

    for {from, :many_to_many, to} <- relations do
      from_s = Macro.underscore(from)
      to_s = Macro.underscore(to)
      ~s/
  defp create_#{to_s}(%{#{from_s}: _}, #{to_s}_params) do
    %#{to}{}
    |> #{to}.changeset(#{to_s}_params)
    |> Repo.insert
  end/
    end
  end

  defp create_from_s_to_to_s(relations) do
    relations = Enum.uniq_by(relations, fn {from, _, to} -> {from, to} end)

    for {from, :many_to_many, to} <- relations do
      from_s = Macro.underscore(from)
      to_s = Macro.underscore(to)
      ~s/
  defp create_#{from_s}_to_#{to_s}(%{#{to_s}: #{to_s}, #{from_s}: #{from_s}}) do
    %#{from}To#{to}{#{to_s}: #{to_s}, #{from_s}: #{from_s}}
    |> Repo.insert
  end/
    end
  end

  defp get_from_to_s(relations) do
    relations =
      relations
      |> Enum.filter(fn {_, r, _} -> r == :many_to_many end)
      |> Enum.map(fn {f, _, t} -> [f, t] end)
      |> List.flatten
      |> Enum.uniq
      |> Enum.map(fn token ->
      token_s = Macro.underscore(token)
      ~s/
  defp get_#{token_s}(_changes, #{token_s}_id) do
    case Repo.get(#{token}, #{token_s}_id) do
      nil -> {:error, "#{token} not found"}
      #{token_s} -> {:ok, #{token_s}}
    end
  end/
      end)
  end

  def query_funcs(relations) do
    relations = Enum.uniq_by(relations, fn {from, _, to} -> {from, to} end)

    for {from, :many_to_many, to} <- relations do
      from_s = Macro.underscore(from)
      to_s = Macro.underscore(to)
      ~s/
  def #{from_s}_add_#{to_s}(#{from_s}_id, #{to_s}_params) do
    Multi.new
    |> Multi.run(:#{from_s}, &get_#{from_s}(&1, #{from_s}_id))
    |> Multi.run(:#{to_s}, &create_#{to_s}(&1, #{to_s}_params))
    |> Multi.run(:#{from_s}_to_#{to_s}, &create_#{from_s}_to_#{to_s}(&1))
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, changes.#{to_s}}
      {:error, :#{to_s}, changeset, _} -> {:error, changeset.errors}
      {:error, :#{from_s}_to_#{to_s}, changeset, _} -> {:error, changeset.errors}
      {:error, _, reason, _} -> {:error, reason}
      {:error, reason} -> {:error, reason}
    end
  end

  def #{from_s}_connect_#{to_s}(#{from_s}_id, #{to_s}_id) do
    Multi.new
    |> Multi.run(:#{from_s}, &get_#{from_s}(&1, #{from_s}_id))
    |> Multi.run(:#{to_s}, &get_#{to_s}(&1, #{to_s}_id))
    |> Multi.run(:#{from_s}_to_#{to_s}, &create_#{from_s}_to_#{to_s}(&1))
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, changes.#{to_s}}
      {:error, :#{to_s}, changeset, _} -> {:error, changeset.errors}
      {:error, :#{from_s}_to_#{to_s}, changeset, _} -> {:error, changeset.errors}
      {:error, _, reason, _} -> {:error, reason}
      {:error, reason} -> {:error, reason}
    end
  end

  def #{from_s}_del_#{to_s}(#{from_s}_id, #{to_s}_id) do
    query =
      from #{from_s}_to_#{to_s} in #{from}To#{to},
        where: [#{from_s}_id: ^#{from_s}_id, #{to_s}_id: ^#{to_s}_id]

    {num, _} =  Repo.delete_all(query)
    {:ok, num}
  end

  def #{from_s}_with_#{to_s}s(#{from_s}_id) do
    query =
      from #{from_s} in #{from},
        where: [id: ^#{from_s}_id],
        preload: :#{to_s}s

    case Repo.one(query) do
      nil -> {:error, "#{from} not found"}
      #{from_s} -> {:ok, #{from_s}}
    end
  end/
    end
  end
end
