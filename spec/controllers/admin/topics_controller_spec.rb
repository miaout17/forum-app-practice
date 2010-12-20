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

end
