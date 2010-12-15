class Admin::CategoriesController < Admin::BaseController
  authorize_resource

  before_filter :find_category, :only => [:create, :edit, :destroy]

  def index
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to(admin_categories_url)
    else
      render :new
    end
  end

  def edit
  end
  
end
