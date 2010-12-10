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
      attachment_ids = params[:attachment_ids].split(",").map { |i| i.to_i }
      attachments = Attachment.where(:id => attachment_ids)
      attachments.each do |attachment|
        attachment.attach(@post)
      end
      redirect_to board_topic_url(@board, @topic)
    else
      render :new
    end

  end

  protected

end

