module ApplicationHelper

  def category_tree
    content_tag(:div, :class => "category-tree") do
      category_node(@root_categories)
    end
  end

  private
  def category_node(categories)
    content_tag(:ul) do
      categories.each do |category|
        item = link_to(category.name, category_path(category))
        item += category_node(category.children) unless category.children.empty?
        concat content_tag(:li, raw(item))
      end
    end
  end

end
