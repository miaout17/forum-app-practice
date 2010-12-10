class TopicsController < ApplicationController

  before_filter :load_categories
  before_filter :find_board
  before_filter :find_topic, :only => [:show]

  def new
    @topic = @board.topics.build
  end

  def create
    @topic = @board.topics.build(params[:topic])
    @post = @topic.posts.build(params[:post])

    if @topic.save
      attachment_ids = params[:attachment_ids].split(",").map { |i| i.to_i }
      @post.attach_by_ids(attachment_ids)
      redirect_to board_topic_path(@board, @topic)
    else
      render :new
    end
  end

  def show
    @posts = @topic.posts.paginate(:per_page => 10, :page => params[:page])
  end

  def preview
    @topic = @board.topics.build(params[:topic])
    @post = @topic.posts.build(params[:post])
  end

  protected

  def find_board
    @board = Board.find(params[:board_id])
  end

  def find_topic
    @topic = @board.topics.find(params[:id])
  end

end
