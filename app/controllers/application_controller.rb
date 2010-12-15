class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_categories

  protected

  def load_categories
    categories = Category.all

    @all_categories = {}
    categories.each do |category| 
      @all_categories[category.id] = category
    end
    @root_categories = categories.select { |category| category.parent_id.nil? }
  end

  def find_category
    # TODO: children still queried from DB, need to optimize
    category_id = (params[:category_id] ? params[:category_id] : params[:id]).to_i
    @category = @all_categories[category_id]
  end

  def find_board
    @board = Board.find(params[:board_id]?params[:board_id]:params[:id]) 
  end

  def find_topic
    @topic = @board.topics.find(params[:topic_id]?params[:topic_id]:params[:id])
  end

  def find_new_attachments
    attachment_ids = params[:attachment_ids].split(",").map { |i| i.to_i }
    @new_attachments = Attachment.where( :id => attachment_ids )
  end

end
