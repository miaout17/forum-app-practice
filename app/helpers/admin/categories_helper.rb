module Admin::CategoriesHelper
  def select_parent_tag(category)
    valid_parents = category.valid_parents
    options = options_from_collection_for_select(valid_parents, :id, :name)
    select(:category, :parent_id, options)
  end
end
