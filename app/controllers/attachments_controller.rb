class AttachmentsController < ApplicationController

  def new
  end

  def create
    attachments_param = params[:attachments]
    # TODO: error message of multiple images upload

    @attachments = []
    attachments_param.each do |key, param|
      attachment = Attachment.new(param)
      unless attachment.save
        render :new
        return
      end
      @attachments << attachment
    end
  end

  before_filter :load_categories

end
