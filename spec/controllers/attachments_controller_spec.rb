require 'spec_helper'

describe AttachmentsController do
  describe "GET new" do
    it "returns a new attachment form" do
      
      # The controller do nothing, let the view render the file field
      get :new
      response.should render_template("new")
    end
  end

  describe "POST create" do
    before(:each) do
     
      # Simulate valid/invalid file info by true/false
      @valid_param = { "1" => true, "2" => true }
      @invalid_param = { "1" => true, "2" => false }

      Attachment.stub!(:new) do |valid|
        attachment = mock_model(Attachment)
        attachment.stub!(:save).and_return(valid)
        attachment
      end
    end

    it "cretes attachments successfully" do
      post :create, {:attachments => @valid_param}
      response.should render_template("create")
    end

    it "failed to create a new topic" do
      post :create, {:attachments => @invalid_param}
      response.should render_template("new")
    end
  end

end
