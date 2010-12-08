class PostsController < ApplicationController

  def new
    @post = @topic.posts.build
  end

  def create
    @post = @topic.posts.build(params[:post])
    if @post.save
      redirect_to board_topic_path(@board, @topic)
    else
      render :new
    end
  end

  protected

  before_filter :find_board
  before_filter :find_topic

  def find_board
    @board = Board.find(params[:board_id])
  end

  def find_topic
    @topic = @board.topics.find(params[:topic_id])
  end

end
