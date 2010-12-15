class Admin::CategoriesController < Admin::BaseController
  authorize_resource

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
  
end
