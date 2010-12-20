require 'spec_helper'

describe Admin::BoardsController do
  include ApplicationSpecHelperMethods

  before(:each) do
    should_authenticate_user
    @current_user.stub!(:admin?).and_return(true) 
    @current_user.stub!(:manager?).and_return(true) 
  end

  def should_find_board
    @board = mock_model(Board)
    controller.should_receive(:find_board) { controller.instance_variable_set("@board", @board) }.ordered
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

  describe "GET edit" do
    it "returns requested board" do
      should_find_board
      get :edit, :id => 2
    end
  end

  describe "PUT update" do
    before(:each) do
      should_find_board
      @params = { "title" => Faker::Lorem.sentence }
    end

    it "update successfully with valid params" do
      @board.should_receive(:update_attributes).with(@params).and_return(true)
      put :update, {
        :id => 3, 
        :board => @params, 
      }
      response.should redirect_to(admin_categories_url)
    end

    it "fails to update with invalid params" do
      @board.should_receive(:update_attributes).with(@params).and_return(false)

      put :update, {
        :id => 3, 
        :board => @params
      }

      assigns(:board).should eq(@board)
      response.should render_template("edit")
    end
  end

  describe "DELETE destroy" do
    it "deletes the request board" do
      should_find_board
      @board.should_receive(:destroy).and_return(true)
      delete :destroy, :id => 3
      response.should redirect_to(admin_categories_url)
    end
  end

end
