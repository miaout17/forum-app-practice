class PostsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_board
  before_filter :find_topic
  before_filter :find_post, :only => [:edit, :update]
  before_filter :find_new_attachments, :only => [:create, :update]
  authorize_resource :only => [:edit, :update]

  rescue_from CanCan::AccessDenied do |exception|
    flash.alert="You are unable to edit this post" 
    redirect_to board_topic_path(@board, @topic)
  end

  def new
    @post = @topic.posts.build
  end

  def create
    @post = @topic.posts.build(params[:post])
    @post.user = current_user

    if @post.save
      @post.obtain_attachments(@new_attachments)
      redirect_to board_topic_url(@board, @topic)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(params[:post])
      @post.obtain_attachments(@new_attachments)
      redirect_to(board_topic_url(@board, @topic))
    else
      render :edit
    end
  end

  protected

  def find_post
    @post = @topic.posts.find(params[:id])
  end

end

