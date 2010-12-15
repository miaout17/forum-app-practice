class Admin::BoardsController < Admin::BaseController
  authorize_resource

  before_filter :find_board, :only => [:edit, :update, :destroy]

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(params[:board])
    if @board.save
      redirect_to(admin_categories_url)
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @board.update_attributes(params[:board])
      redirect_to(admin_categories_url)
    else
      render "edit"
    end
  end

end
