class BoardsController < ApplicationController

  def show
    @topics = @board.topics
  end
  
  protected

  before_filter :find_board, :only => [:show]

  def find_board
    @board = Board.find(params[:id])
  end

end
