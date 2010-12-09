class AttachmentsController < ApplicationController

  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.new(params[:attachment])

    # TODO: Attachment Security?
    if @attachment.save
      redirect_to attachment_path(@attachment) 
    else
      render :new
    end
  end

  def show
    @attachment = Attachment.find(params[:id])
  end

  before_filter :load_categories

end
