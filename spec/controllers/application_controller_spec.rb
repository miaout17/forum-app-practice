require 'spec_helper'

describe ApplicationController do
  it "#load_categories" do
    @category = mock_model(Category)
    @category.stub!(:parent).and_return(nil)
    @categories = [ @category ]

    Category.should_receive(:all).and_return(@categories)
    controller.send(:load_categories)

    assigns(:all_categories).count.should == 1
    assigns(:all_categories)[ @category.id ].should eq(@category)

    assigns(:root_categories).count.should == 1
    assigns(:root_categories).should include(@category)
  end
end
