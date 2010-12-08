class TopicsController < ApplicationController

  def new
    @topic = @board.topics.build
  end

  def create
    @topic = @board.topics.build(params[:topic])
    @post = @topic.posts.build(params[:post])

    if @topic.save
      redirect_to board_topic_path(@board, @topic)
    else
      render :new
    end
  end

  def show
    @posts = @topic.posts # Todo: pagination
  end

  protected

  before_filter :find_board
  before_filter :find_topic, :only => [:show]

  def find_board
    @board = Board.find(params[:board_id])
  end

  def find_topic
    @topic = @board.topics.find(params[:id])
  end

end