class TopicsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :find_board
  before_filter :find_topic, :only => [:show]
  before_filter :find_new_attachments, :only => [:create]

  def new
    @topic = @board.topics.build
  end

  def create
    @topic = @board.topics.build(params[:topic])
    @post = @topic.posts.build(params[:post])

    @topic.user = current_user
    @post.user = current_user

    if @topic.save
      @post.obtain_attachments(@new_attachments)
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
