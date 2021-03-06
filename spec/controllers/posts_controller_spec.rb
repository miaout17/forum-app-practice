require 'spec_helper'

describe PostsController do
  
  include ApplicationSpecHelperMethods

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

  it "#find_post" do
    @topic = mock_model(Topic)
    @post = mock_model(Post)
    @posts = []

    controller.params = {:board_id => 4, :topic_id => 3, :id => 2}
    controller.instance_variable_set("@topic", @topic)

    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:find).with(2).and_return(@post)

    controller.send(:find_post)
    assigns(:post).should eq(@post)
  end

  it "#find_new_attachments" do
    @new_attachments = [ mock_model(Attachment), mock_model(Attachment) ]
    @attachment_ids = "3,5"
    controller.params = { :attachment_ids => @attachment_ids }

    Attachment.should_receive(:where).with(:id => [3,5]).and_return(@new_attachments)
    controller.send(:find_new_attachments)
    assigns(:new_attachments).should eq(@new_attachments)
  end

  def should_find_board
    @board = mock_model(Board)
    controller.should_receive(:find_board) { controller.instance_variable_set("@board", @board) }.ordered
  end

  def should_find_topic
    @topic = mock_model(Topic)
    @topic.stub!(:status).and_return("published")
    controller.should_receive(:find_topic) { controller.instance_variable_set("@topic", @topic) }.ordered
  end

  def should_find_post
    @post = mock_model(Post)
    @post.stub!(:status).and_return("published")
    @post.stub!(:topic).and_return(@topic)
    controller.should_receive(:find_post) { controller.instance_variable_set("@post", @post) }.ordered
  end

  def should_require_author
    @post.should_receive(:user_id).and_return(@current_user.id)
    # controller.should_receive(:can?).with(:update, @post).and_return(true)
  end

  def should_redirect_unless_author
    another_user = mock_model(User)
    @post.should_receive(:user_id).and_return(another_user.id)
    # controller.should_receive(:can?).with(:update, @post).and_return(false)
    yield
    response.should redirect_to(board_topic_url(@board, @topic))
  end

  def should_find_new_attachments 
    @new_attachments = [ mock_model(Attachment), mock_model(Attachment) ]
    controller.should_receive(:find_new_attachments) {
      controller.instance_variable_set("@new_attachments", @new_attachments)
    }.ordered
  end

  describe "GET new" do
    it "returns a new post form" do
      should_authenticate_user
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
      should_authenticate_user
      should_find_board
      should_find_topic
      should_find_new_attachments

      @posts = []
      @topic.stub!(:posts).and_return(@posts)
      @post  = mock_model(Post)

      @params = { "content" => Faker::Lorem.sentence }
      @posts.should_receive(:build).with(@params).and_return(@post)
      @post.should_receive(:user=).with(@current_user)
    end

    it "creates successfully" do
      @post.should_receive(:save).and_return(true)
      @post.should_receive(:obtain_attachments).with(@new_attachments)

      post :create, {
        :board_id => 4, 
        :topic_id => 6,
        :post => @params, 
        :attachment_ids => "3,5"
      }

      response.should redirect_to(board_topic_path(@board, @topic))
    end

    it "fails to create" do
      @post.should_receive(:save).and_return(false)

      post :create, {:board_id => 4, :topic_id => 6, :post => @params}

      assigns(:post).should eq(@post)
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    before(:each) do
      should_authenticate_user
      should_find_board
      should_find_topic
      should_find_post
    end

    it "returns requested post" do
      should_require_author

      get :edit, :board_id => 4, :topic_id => 3, :id => 2

      assigns(:post).should eq(@post)
      response.should render_template("edit")
    end

    it "should redirect without edit premission" do
      should_redirect_unless_author do
        get :edit, :board_id => 4, :topic_id => 3, :id => 2
      end
    end
  end

  describe "PUT update" do
    before :each do
      should_authenticate_user
      should_find_board
      should_find_topic
      should_find_post
      should_find_new_attachments
      @params = { 
        "content" => Faker::Lorem.sentence 
      }
    end

    it "update successfully with valid params" do
      should_require_author
      @post.should_receive(:update_attributes).with(@params).and_return(true)
      @post.should_receive(:obtain_attachments).with(@new_attachments)

      post :update, {
        :board_id => 4, 
        :topic_id => 6,
        :id => 3, 
        :post => @params, 
        :attachment_ids => "3,5"
      }

      response.should redirect_to(board_topic_url(@board, @topic))
    end

    it "fails to update with invalid params" do
      should_require_author
      @post.should_receive(:update_attributes).with(@params).and_return(false)

      put :update, {:board_id => 4, :topic_id => 2, :id => 3, :post => @params}

      assigns(:post).should eq(@post)
      response.should render_template("edit")
    end

    it "should redirect without edit premission" do
      should_redirect_unless_author do
        put :update, {:board_id => 4, :topic_id => 2, :id => 3, :post => @params}
      end
    end
  end

end

