defmodule Nice.API.ProfileView do
  use Nice.Web, :view

  def render("index.json", %{profiles: profiles}) do
    %{data: render_many(profiles, Nice.API.ProfileView, "profile.json")}
  end

  def render("show.json", %{profile: profile}) do
    %{data: render_one(profile, Nice.API.ProfileView, "profile.json")}
  end

  def render("profile.json", %{profile: profile}) do
    %{id: profile.id,
      gender: profile.gender,
      age: profile.age,
      avatar: profile.avatar}
  end
end
