require 'spec_helper'

describe Admin::CategoriesController do
  include ApplicationSpecHelperMethods

  def should_find_category
    @category = mock_model(Category)
    controller.should_receive(:find_category) { controller.instance_variable_set("@category", @category) }.ordered
  end

  before(:each) do
    should_authenticate_user
    @current_user.stub!(:manager?).and_return(true)
    @current_user.stub!(:admin?).and_return(true)
  end

  describe "GET index" do
    it "shows category tree" do
      # should_authorize_resource
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

  describe "PUT update" do
    before :each do
      should_find_category
      @params = { "title" => Faker::Lorem.sentence }
    end

    it "update successfully with valid params" do
      @category.should_receive(:update_attributes).with(@params).and_return(true)
      post :update, {
        :id => 3, 
        :category => @params, 
      }
      response.should redirect_to(admin_categories_url)
    end

    it "fails to update with invalid params" do
      @category.should_receive(:update_attributes).with(@params).and_return(false)

      put :update, {
        :id => 3, 
        :category => @params
      }

      assigns(:category).should eq(@category)
      response.should render_template("edit")
    end
  end

  describe "DELETE destroy" do
    it "should redirect without admin premission" do
      should_find_category
      @category.should_receive(:destroy).and_return(true)
      delete :destroy, :id => 3
      response.should redirect_to(admin_categories_url)
    end
  end

end

