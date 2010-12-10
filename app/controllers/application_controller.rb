class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def load_categories
    categories = Category.all

    @all_categories = {}
    categories.each do |category| 
      @all_categories[category.id] = category
    end
    @root_categories = categories.select { |category| category.parent_id.nil? }
  end

end
