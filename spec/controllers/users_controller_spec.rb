require 'spec_helper'

describe UsersController do

  it "#find_user" do
    @user = mock_model(User)
    controller.params = {:id => @user.id}

    User.should_receive(:find).with(@user.id).and_return(@user)
    controller.send(:find_user)

    assigns(:user).should eq(@user)
  end

  def should_find_user
    @user = mock_model(User)
    controller.should_receive(:find_user) { controller.instance_variable_set("@user", @user) }.ordered
  end

  describe "GET show" do
    it "gets the user by id" do
      should_find_user
      get :show, :id => 4
    end
  end

end
