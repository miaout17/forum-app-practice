class CategoriesController < ApplicationController

  def show
    @topics = @category.descendant_topics
    @topics = @topics.paginate :per_page => 10, :page => params[:page]
  end

  protected
  
  before_filter :load_categories
  before_filter :find_category, :only => [:show]

  def find_category
    # TODO: children still queried from DB, need to optimize
    @category = @all_categories[params[:id].to_i]
  end

end
