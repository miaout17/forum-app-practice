class BoardsController < ApplicationController

  before_filter :load_categories, :only => [:show]
  before_filter :find_board, :only => [:show]

  def show
    @topics = @board.topics.paginate(:per_page => 10, :page => params[:page])
  end
  
  protected

end
