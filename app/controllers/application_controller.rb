class ApplicationController < ActionController::Base
  protect_from_forgery

  def load_categories
    categories = Category.all

    @all_categories = {}
    categories.each do |category| 
      @all_categories[category.id] = category
    end
    @root_categories = categories.select { |category| category.parent==nil }

  end
end
