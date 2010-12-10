require 'spec_helper'

describe TopicsController do

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

    controller.params = {:board_id => 4, :id => 3}
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

  describe "GET show" do
    it "returns the topic ant its posts" do
      should_find_board
      should_find_topic
      @posts = []
      @topic.stub!(:posts).and_return(@posts)

      @posts.should_receive(:paginate).with(:per_page => 10, :page => 3).and_return(@posts)

      get :show, :board_id => 4, :id => 6, :page => 3

      assigns(:posts).should eq(@posts)
      response.should render_template("show")
    end
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
      @post.should_receive(:attach_by_ids).with([4, 7])

      post :create, {
        :board_id => 4,
        :topic => @topic_params, 
        :post => @post_params,
        :attachment_ids => "4,7"
      }
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

  describe "PUT preview" do
    it "renders the topics preview do" do
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

      put :preview, {:board_id => 4, :topic => @topic_params, :post => @post_params}

      assigns(:topic).should eq(@topic)
      assigns(:post).should eq(@post)

      response.should render_template("preview")
    end

  end
end

