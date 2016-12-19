defmodule <%= module %>Controller do
  use <%= base %>.Web, :controller

  alias <%= module %>

<%= for {from_module, connect_module, from_id} <- from_items do %>
  def index(conn, %{<%= inspect from_id %> => id} = params) do
    q = from c in <%= from_module %>,
      where: [id: ^id],
      preload: :<%= field_key %>,
      select: c

    c = Repo.one(q)

    render(conn, "index.html", <%= field_key %>: c.<%= field_key %>, params: params)
  end
<% end %>

  def index(conn, params) do
    <%= field_key %> = Repo.all(<%= alias %>)
    render(conn, "index.html", <%= field_key %>: <%= field_key %>, params)
  end

  def new(conn, params) do
    changeset = <%= alias %>.changeset(%<%= alias %>{})
    render(conn, "new.html", changeset: changeset, params: params)
  end

<%= for {from_module, connect_module, from_id} <- from_items do %>
  def create(conn, %{<%= inspect singular %> => <%= singular %>_params, <%= inspect from_id %> => <%= from_id %>}) do
    {_, result} =
      Repo.transaction fn ->
        changeset = <%= alias %>.changeset(%<%= alias %>{}, <%= singular %>_params)
        with {:ok, %{id: product_id}} <- Repo.insert(changeset) do
          ctp_params = %{
            <%= singular %>_id: <%= singular %>_id,
            <%= from_id %>: <%= from_id %>
          }

          %<%= connect_module %>{}
          |> <%= connect_module %>(ctp_params)
          |> Repo.insert()
        end
      end

    case result do
      {:ok, _<%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> created successfully.")
        |> redirect(to: <%= singular %>_path(conn, :index, %{<%= inspect from_id %> => <%= from_id %>}))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{<%= inspect from_id %> => <%= from_id %>})
    end
  end
<% end %>

  def create(conn, %{<%= inspect singular %> => <%= singular %>_params} = params) do
    changeset = <%= alias %>.changeset(%<%= alias %>{}, <%= singular %>_params)

    case Repo.insert(changeset) do
      {:ok, _<%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> created successfully.")
        |> redirect(to: <%= singular %>_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{})
    end
  end

  def show(conn, %{"id" => id}) do
    <%= singular %> = Repo.get!(<%= alias %>, id)
    render(conn, "show.html", <%= singular %>: <%= singular %>)
  end

  def edit(conn, %{"id" => id}) do
    <%= singular %> = Repo.get!(<%= alias %>, id)
    changeset = <%= alias %>.changeset(<%= singular %>)
    render(conn, "edit.html", <%= singular %>: <%= singular %>, changeset: changeset)
  end

  def update(conn, %{"id" => id, <%= inspect singular %> => <%= singular %>_params}) do
    <%= singular %> = Repo.get!(<%= alias %>, id)
    changeset = <%= alias %>.changeset(<%= singular %>, <%= singular %>_params)

    case Repo.update(changeset) do
      {:ok, <%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> updated successfully.")
        |> redirect(to: <%= singular %>_path(conn, :show, <%= singular %>))
      {:error, changeset} ->
        render(conn, "edit.html", <%= singular %>: <%= singular %>, changeset: changeset)
    end
  end

<%= for {_, _, from_id} <- from_items do %>
  def delete(conn, %{"id" => id, <%= inspect from_id %> => <%= from_id %>}) do
    <%= singular %> = Repo.get!(<%= alias %>, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(<%= singular %>)

    conn
    |> put_flash(:info, "<%= human %> deleted successfully.")
    |> redirect(to: <%= singular %>_path(conn, :index, %{<%= inspect from_id %> => <%= from_id %>}))
  end
<% end %>

  def delete(conn, %{"id" => id}) do
    <%= singular %> = Repo.get!(<%= alias %>, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(<%= singular %>)

    conn
    |> put_flash(:info, "<%= human %> deleted successfully.")
    |> redirect(to: <%= singular %>_path(conn, :index))
  end
end
