class CategoriesController < ApplicationController

  before_filter :find_category, :only => [:show]

  def show
    @topics = @category.descendant_topics.accessible_by(current_ability).paginate(:per_page => 10, :page => params[:page])
  end

end
