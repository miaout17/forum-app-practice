require 'spec_helper'

describe PostsController do
  it "#find_board" do
    @board = mock_model(Board)
    controller.params = {:board_id => 4}

    Board.should_receive(:find).with(4).and_return(@board)
    controller.send(:find_board)

    assigns(:board).should eq(@board)
  end

  it "#find_topic" do
    @board = mock_model(Board)
    @topic = mock_model(Topic)
    @topics = []

    controller.params = {:board_id => 4, :topic_id => 3}
    controller.instance_variable_set("@board", @board)

    @board.should_receive(:topics).and_return(@topics)
    @topics.should_receive(:find).with(3).and_return(@topic)

    controller.send(:find_topic)
    assigns(:topic).should eq(@topic)
  end

  def should_find_board
    @board = mock_model(Board)
    controller.should_receive(:find_board) { controller.instance_variable_set("@board", @board) }.ordered
  end

  def should_find_topic
    @topic = mock_model(Topic)
    controller.should_receive(:find_topic) { controller.instance_variable_set("@topic", @topic) }.ordered
  end

  describe "GET new" do
    it "returns a new post form" do
      should_find_board
      should_find_topic

      @posts = []
      @post = mock_model(Post)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:build).and_return(@post)

      get :new, :board_id => 4, :topic_id => 6

      assigns(:post).should eq(@post)
      response.should render_template("new")
    end
  end

  describe "POST create" do
    before :each do
      should_find_board
      should_find_topic

      @posts = []
      @topic.stub!(:posts).and_return(@posts)
      @post  = mock_model(Post)

      @params = { "content" => Faker::Lorem.sentence }
      @posts.should_receive(:build).with(@params).and_return(@post)
    end

    it "creates successfully" do
      @post.should_receive(:save).and_return(true)

      post :create, {:board_id => 4, :topic_id => 6, :post => @params}

      response.should redirect_to(board_topic_path(@board, @topic))
    end

    it "fails to create" do
      @post.should_receive(:save).and_return(false)

      post :create, {:board_id => 4, :topic_id => 6, :post => @params}

      assigns(:post).should eq(@post)
      response.should render_template("new")
    end

  end

end
