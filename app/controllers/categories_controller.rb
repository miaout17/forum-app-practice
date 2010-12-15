class CategoriesController < ApplicationController

  before_filter :find_category, :only => [:show]

  def show
    @topics = @category.descendant_topics.paginate(:per_page => 10, :page => params[:page])
  end

end
