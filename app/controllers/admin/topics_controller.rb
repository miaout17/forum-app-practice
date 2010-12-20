class Admin::TopicsController < Admin::BaseController
  before_filter :find_board
  before_filter :find_topic, :only => [:edit, :update, :destroy]

  authorize_resource

  def index
    authorize!(:manage_content, @board)
    @topics = @board.topics.paginate(:per_page => 10, :page => params[:page])
  end

end
