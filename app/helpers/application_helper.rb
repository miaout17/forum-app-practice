module ApplicationHelper
  def user_link(user)
    link_to(user.name, user_path(user))
  end
end
