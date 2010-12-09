class BoardsController < ApplicationController

  def show
    @topics = @board.topics
    @topics = @topics.paginate :per_page => 10, :page => params[:page]
  end
  
  protected

  before_filter :load_categories, :only => [:show]
  before_filter :find_board, :only => [:show]

  def find_board
    @board = Board.find(params[:id])
  end

end
