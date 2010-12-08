require 'spec_helper'

describe CategoriesController do
  
  it "#find_category" do
    @category = mock_model(Category)
    controller.params = {:id => 3}

    Category.should_receive(:find).with(3).and_return(@category)
    controller.send(:find_category)

    assigns(:category).should eq(@category)
  end

  def should_find_category
    @category = mock_model(Category)
    controller.should_receive(:find_category) { controller.instance_variable_set("@category", @category) }.ordered
  end

  describe "GET show" do
    it "returns the category and descendant topics" do
      should_find_category

      @topics = [ mock_model(Topic) ]
      @category.should_receive(:descendant_topics).and_return(@topics)

      get :show, :id => 6

      assigns(:topics).should eq(@topics)
      response.should render_template("show")
    end
  end

end
