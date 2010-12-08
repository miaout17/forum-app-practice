class CategoriesController < ApplicationController

  def show
    @topics = @category.descendant_topics
    @topics = @topics.paginate :per_page => 10, :page => params[:page]
  end

  protected

  before_filter :find_category, :only => [:show]

  def find_category
    @category = Category.find(params[:id])
  end

end
