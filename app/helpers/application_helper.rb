module ApplicationHelper

  def category_tree
    content_tag(:div, :class => "category-tree") do
      content_tag(:ul) do
        @root_categories.each do |category|
          concat category_node(category)
        end
      end
    end
  end

  private
  
  def category_node(category)
    content_tag(:li) do
      concat link_to(category.name, category_path(category))
      unless category.children.empty? and category.boards.empty?
        concat category_children_node(category)
      end
    end
  end

  def category_children_node(category)
    content_tag(:ul) do
      category.children.each do |subcategory|
        concat category_node(subcategory)
      end
      category.boards.each do |board|
        concat content_tag(:li, link_to(board.name, board_path(board)))
      end
    end
  end

  # def category_node(categories)
  #   content_tag(:ul) do
  #     categories.each do |category|
  #       item = link_to(category.name, category_path(category))
  #       unless category.children.empty? and category.boards.empty?
  #         category_node(category.children) 
  #       end
  #       concat content_tag(:li, raw(item))
  #     end
  #   end
  # end

end
