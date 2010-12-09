class AttachmentsController < ApplicationController

  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.new(params[:attachment])

    # Todo: Attachment Security?
    if @attachment.save
      redirect_to attachment_path(@attachment) 
    else
      render :new
    end
  end

  def show
    @attachment = Attachment.find(params[:id])
  end

end
