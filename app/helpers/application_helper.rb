module ApplicationHelper
  def user_link(user)
    link_to(user.name, user_path(user))
  end

  def user_icon_tag(user, style = :icon)
    return default_user_icon_tag(style) unless user.icon.exists?
    return image_tag(user.icon.url(style))
  end

  private
  def default_user_icon_tag(style)
    # TODO: move the magic number to somewhere else
    # Give another default image rather than rails.png?
    size = case style
      when :icon then 32
      when :thumb then 100
    end
    return image_tag("/images/rails.png", :width => size, :height => size)
  end
end
