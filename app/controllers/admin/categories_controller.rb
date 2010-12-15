class Admin::CategoriesController < Admin::BaseController
  authorize_resource

  before_filter :find_category, :only => [:edit, :update, :destroy]

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

  def update
    if @category.update_attributes(params[:category])
      redirect_to(admin_categories_url)
    else
      render "edit"
    end
  end

  def destroy
    @category.destroy
    redirect_to(admin_categories_url)
  end
  
end
