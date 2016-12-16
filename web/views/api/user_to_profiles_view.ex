defmodule Nice.API.UserToProfilesView do
  use Nice.Web, :view

  def render("index.json", %{user_to_profiles: user_to_profiles}) do
    %{data: render_many(user_to_profiles, Nice.API.UserToProfilesView, "user_to_profiles.json")}
  end

  def render("show.json", %{user_to_profiles: user_to_profiles}) do
    %{data: render_one(user_to_profiles, Nice.API.UserToProfilesView, "user_to_profiles.json")}
  end

  def render("user_to_profiles.json", %{user_to_profiles: user_to_profiles}) do
    %{id: user_to_profiles.id,
      user_id: user_to_profiles.user_id,
      profile_id: user_to_profiles.profile_id}
  end
end
