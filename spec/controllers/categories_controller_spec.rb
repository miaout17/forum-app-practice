require 'spec_helper'

describe CategoriesController do

  include ApplicationSpecHelperMethods
  
  it "#find_category" do
    @category = mock_model(Category)
    @all_categories = { @category.id => @category }
    controller.instance_variable_set("@all_categories", @all_categories)

    controller.params = {:id => @category.id}
    controller.send(:find_category)

    assigns(:category).should eq(@category)
  end

  def should_find_category
    @category = @root_categories.first
    controller.should_receive(:find_category) { controller.instance_variable_set("@category", @category) }.ordered
  end

  describe "GET show" do
    it "returns the category and descendant topics" do
      should_load_categories
      should_find_category

      @topics = [ mock_model(Topic) ]
      @category.should_receive(:descendant_topics).and_return(@topics)
      @topics.should_receive(:paginate).with(:per_page => 10, :page => 7).and_return(@topics)

      get :show, :id => 6, :page => 7

      assigns(:topics).should eq(@topics)
      response.should render_template("show")
    end
  end

end
