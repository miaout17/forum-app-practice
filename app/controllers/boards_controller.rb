class BoardsController < ApplicationController

  before_filter :find_board, :only => [:show]

  def show
    @topics = @board.topics.accessible_by(current_ability).paginate(:per_page => 10, :page => params[:page])
  end
  
  protected

end
