require 'spec_helper'

describe BoardsController do
  it "#find_board" do
    @board = mock_model(Board)
    controller.params = {:id => 4}

    Board.should_receive(:find).with(4).and_return(@board)
    controller.send(:find_board)

    assigns(:board).should eq(@board)
  end

  def should_find_board
    @board = mock_model(Board)
    controller.should_receive(:find_board) { controller.instance_variable_set("@board", @board) }.ordered
  end

  describe "GET show" do
    it "returns the board and its topics" do
      controller.stub!(:current_user).and_return(nil)
      should_find_board
      @topics = []
      @topics.should_receive(:accessible_by).and_return(@topics)
      @board.stub!(:topics).and_return(@topics)
      @topics.should_receive(:paginate).with(:per_page => 10, :page => 7).and_return(@topics)

      get :show, :id => 6, :page => 7

      assigns(:topics).should eq(@topics)
      response.should render_template("show")
    end
  end
end
