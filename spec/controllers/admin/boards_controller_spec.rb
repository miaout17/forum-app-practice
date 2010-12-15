require 'spec_helper'

describe Admin::BoardsController do
  include ApplicationSpecHelperMethods

  before(:each) do
    should_authenticate_user
    @current_user.stub!(:admin?).and_return(true) #TODO: manager
  end
  
  describe "GET new" do
    it "returs new board form" do
      should_authorize_resource

      @board = mock_model(Board)
      Board.should_receive(:new).and_return(@board)
      get :new

      assigns(:board).should eq(@board)
      response.should render_template("new")
    end
  end

  describe "POST create" do
    before(:each) do
      @params = { "title" => Faker::Lorem.sentence }
      @board = mock_model(Board)
      Board.should_receive(:new).with(@params).and_return(@board)
    end

    it "creates successfully" do
      @board.should_receive(:save).and_return(true)
      post :create, :board => @params
      response.should redirect_to(admin_categories_url)
    end

    it "fails to create" do
      @board.should_receive(:save).and_return(false)
      post :create, :board => @params
      assigns(:board).should eq(@board)
      response.should render_template("new")
    end
  end

  pending "GET edit"
  pending "PUT update"
  pending "DELETE destroy"

end
