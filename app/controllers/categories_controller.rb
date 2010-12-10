class CategoriesController < ApplicationController

  before_filter :find_category, :only => [:show]

  def show
    @topics = @category.descendant_topics.paginate(:per_page => 10, :page => params[:page])
  end

  protected

  def find_category
    # TODO: children still queried from DB, need to optimize
    @category = @all_categories[params[:id].to_i]
  end

end
