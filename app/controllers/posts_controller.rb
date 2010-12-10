class PostsController < ApplicationController

  before_filter :load_categories
  before_filter :find_board
  before_filter :find_topic

  def new
    @post = @topic.posts.build
  end

  def create
    @post = @topic.posts.build(params[:post])
    if @post.save
      redirect_to board_topic_url(@board, @topic)
    else
      render :new
    end
  end

  protected

  def find_board
    @board = Board.find(params[:board_id])
  end

  def find_topic
    @topic = @board.topics.find(params[:topic_id])
  end

end

