class CategoriesController < ApplicationController

  def show
    @topics = @category.descendant_topics
  end

  protected

  before_filter :find_category, :only => [:show]

  def find_category
    @category = Category.find(params[:id])
  end

end
