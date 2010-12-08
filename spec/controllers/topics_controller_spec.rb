require 'spec_helper'

describe TopicsController do

  it "#find_board" do
    @board = mock_model(Board)
    controller.params = {:board_id => 4}

    Board.should_receive(:find).with(4).and_return(@board)
    controller.send(:find_board)

    assigns(:board).should eq(@board)
  end

  def should_find_board
    @board = mock_model(Board)
    controller.should_receive(:find_board) { controller.instance_variable_set("@board", @board) }.ordered
  end


  describe "GET new" do
    it "returns a new topic form" do
      should_find_board
      @topics = []
      @topic = mock_model(Topic)

      @board.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:build).and_return(@topic)

      get :new, :board_id => 4

      assigns(:topic).should eq(@topic)
      response.should render_template("new")
    end
  end

  describe "POST create" do
    before(:each) do
      should_find_board
      
      @topics = []
      @topic = mock_model(Topic)
      @posts = []
      @post  = mock_model(Post)

      @topic_params = { :title => "TITLE" }
      @post_params = { :content => "CONTENT" }

      @board.stub!(:topics).and_return(@topics)
      @topics.should_receive(:build).and_return(@topic)

      @topic.stub!(:posts).and_return(@posts)
      @posts.should_receive(:build).and_return(@post)
    end

    it "cretes a new topic successfully" do
      @topic.should_receive(:save).and_return(true)
      post :create, {:board_id => 4, :topic => @topic_params, :post => @post_params}
      response.should redirect_to(board_topic_path(@board, @topic))
    end

    it "failed to create a new topic" do
      @topic.should_receive(:save).and_return(false)
      post :create, {:board_id => 4, :topic => @topic_params, :post => @post_params}

      assigns(:topic).should eq(@topic)
      assigns(:post ).should eq(@post)
      response.should render_template("new")
    end

  end
end
