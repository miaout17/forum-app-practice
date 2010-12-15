require 'spec_helper'

describe Admin::CategoriesController do
  include ApplicationSpecHelperMethods

  def should_find_category
    @category = mock_model(Category)
    controller.should_receive(:find_category) { controller.instance_variable_set("@category", @category) }.ordered
  end

  before(:each) do
    should_authenticate_user
    @current_user.stub!(:admin?).and_return(true) #TODO: manager
  end

  describe "GET index" do
    it "shows category tree" do
      should_authorize_resource
      get :index
    end
  end

  describe "GET new" do
    it "returns a new category form" do
      should_authorize_resource

      @category = mock_model(Category)
      Category.should_receive(:new).and_return(@category)
      get :new

      assigns(:category).should eq(@category)
      response.should render_template("new")
    end
  end

  describe "POST create" do
    before(:each) do
      @params = { "title" => Faker::Lorem.sentence }
      @category = mock_model(Category)
      Category.should_receive(:new).with(@params).and_return(@category)
    end

    it "creates successfully" do
      @category.should_receive(:save).and_return(true)
      post :create, :category => @params
      response.should redirect_to(admin_categories_url)
    end

    it "fails to create" do
      @category.should_receive(:save).and_return(false)
      post :create, :category => @params
      assigns(:category).should eq(@category)
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    before(:each) do
      should_find_category
    end

    it "returns requested category" do
      get :edit, :id => 2
      assigns(:category).should eq(@category)
      response.should render_template("edit")
    end
  end

end

