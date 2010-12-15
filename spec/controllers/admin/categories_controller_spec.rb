require 'spec_helper'

describe Admin::CategoriesController do
  include ApplicationSpecHelperMethods

  before(:each) do
    should_authenticate_user
    @current_user.stub!(:admin?).and_return(true) #TODO: manager
  end

  def should_load_resource(*resources)
  end

  def should_authorize_resource
    controller.should_receive(:authorize_resource!) do
      raise
    end
  end

  describe "GET index" do
    it "hello" do
      should_load_resource(:categories)
      should_authorize_resource

      get :index
    end
  end

end

