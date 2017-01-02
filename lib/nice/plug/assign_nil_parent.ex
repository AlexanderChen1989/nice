defmodule Nice.Plug.AssignNilParent do
  use Plug.Builder

  def call(conn, _) do
    conn
    |> assign(:parent, nil)
  end
end
