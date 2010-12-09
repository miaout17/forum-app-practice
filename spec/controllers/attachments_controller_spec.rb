require 'spec_helper'

describe AttachmentsController do
  describe "GET new" do
    it "returns a new attachment form" do
      @attachment = mock_model(Attachment)
      Attachment.should_receive(:new).and_return(@attachment)

      get :new

      assigns(:attachment).should eq(@attachment)
      response.should render_template("new")
    end
  end

  describe "POST create" do
    before(:each) do
      @params = {}

      @attachment = mock_model(Attachment)
      Attachment.should_receive(:new).with(@params).and_return(@attachment)
    end

    it "cretes a new topic successfully" do
      @attachment.should_receive(:save).and_return(true)
      post :create, {:attachment => @params}

      response.should redirect_to(attachment_path(@attachment))
    end

    it "failed to create a new topic" do
      @attachment.should_receive(:save).and_return(false)
      post :create, {:attachment => @params}

      response.should render_template("new")
    end

  end

end
