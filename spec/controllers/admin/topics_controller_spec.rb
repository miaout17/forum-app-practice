require 'spec_helper'

describe Admin::TopicsController do
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

  def should_find_topic
    @topic = mock_model(Topic)
    controller.should_receive(:find_topic) { controller.instance_variable_set("@topic", @topic) }.ordered
  end

  describe "GET index" do
    it "returns the board and its topics" do
      should_find_board
      @topics = []
      @board.stub!(:topics).and_return(@topics)
      @topics.should_receive(:paginate).with(:per_page => 10, :page => 7).and_return(@topics)

      get :index, :board_id => 6, :page => 7

      assigns(:topics).should eq(@topics)
      response.should render_template("index")
    end
  end

  describe "GET edit" do
    it "returns requested topic" do
      should_find_board
      should_find_topic

      get :edit, :board_id => 4, :id => 3

      assigns(:topic).should eq(@topic)
      response.should render_template("edit")
    end
  end

  describe "PUT update" do
    before(:each) do
      should_find_board
      should_find_topic
      @params = { 
        "title" => Faker::Lorem.sentence 
      }
    end

    it "update successfully with valid params" do
      @topic.should_receive(:update_attributes).with(@params).and_return(true)

      post :update, {
        :board_id => 4, 
        :id => 3, 
        :topic => @params, 
      }

      response.should redirect_to(admin_board_topic_url(@board, @topic))
    end

    it "fails to update with invalid params" do
      @topic.should_receive(:update_attributes).with(@params).and_return(false)

      post :update, {
        :board_id => 4, 
        :id => 3, 
        :topic => @params, 
      }

      assigns(:topic).should eq(@topic)
      response.should render_template("edit")
    end

  end

  describe "DELETE destroy" do
    it "soft_delete requested topic" do
      should_find_board
      should_find_topic
      @topic.should_receive(:soft_delete).and_return(true)
      delete :destroy, :board_id => 3, :id => 2
      response.should redirect_to(admin_board_topics_url(@board))
    end
  end

  describe "PUT undelete" do
    it "soft_undelete requested topic" do
      should_find_board
      should_find_topic
      @topic.should_receive(:soft_undelete).and_return(true)
      put :undelete, :board_id => 3, :id => 2
      response.should redirect_to(admin_board_topics_url(@board))
    end
  end

end

