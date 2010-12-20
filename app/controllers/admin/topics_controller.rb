class Admin::TopicsController < Admin::BaseController
  before_filter :find_board
  before_filter :find_topic, :only => [:edit, :update, :destroy]

  authorize_resource

  def index
    authorize!(:manage_content, @board)
    @topics = @board.topics.paginate(:per_page => 10, :page => params[:page])
  end

  def edit
  end

  def update
    if @topic.update_attributes(params[:topic])
      redirect_to(admin_board_topic_url(@board, @topic))
    else
      render("edit")
    end
  end

end
