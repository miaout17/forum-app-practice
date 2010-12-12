module ApplicationHelper
  def user_link(user)
    link_to(user.name, user_path(user))
  end

  def user_icon_tag(user, style = :icon)
    return "" if user.nil?
    return "" unless user.icon.exists?
    return image_tag(user.icon.url(style))
  end
end
