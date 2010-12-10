class AttachmentsController < ApplicationController

  def new
    # The controller do nothing, let the view render the file field
  end

  def create
    attachments_param = params[:attachments]
    # TODO: error message of multiple images upload

    @attachments = attachments_param.collect do |key, param|
      Attachment.new(param)
    end

    if @attachments.all? { |attachment| attachment.save }
      render :create
    else
      render :new
    end
    
  end

  before_filter :load_categories

end
