# == Schema Information
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  name                 :string(255)
#  icon_file_name       :string(255)
#  icon_content_type    :string(255)
#  icon_file_size       :integer
#  icon_updated_at      :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#

require 'spec_helper'

describe User do
  describe "validator" do
    before :each do
      @params = {
        :email => "unique-email@mail.com", 
        :name => "helloworld", 
        :password => "123456"
      }
    end

    it "is valid with valid attributes" do
      User.new(@params).should be_valid
    end

    it "must have email" do
      User.new(@params.except(:email)).should_not be_valid
    end

    it "must have name" do
      User.new(@params.except(:name)).should_not be_valid
    end

    it "must have password" do
      User.new(@params.except(:password)).should_not be_valid
    end

    it "user name must be unique" do
      user = User.new(@params)
      user.save!

      new_user = Factory.build(:user, :name => @params[:name])
      new_user.should_not be_valid
    end

  end

  describe "normal user" do

    before(:each) do
      @user = Factory(:user)
      @ability = Ability.new(@user)
      @other_user = Factory(:user)
      @other_user_ability = Ability.new(@other_user)
    end

    it "could get its topics" do
      topic = Factory(:topic, :user => @user)
      @user.reload
      @user.topics.should =~ [topic]
    end

    it "could get its posts" do
      topic = Factory(:topic, :user => @user)
      post = Factory(:post, :user => @user, :topic => topic)
      other_topic = Factory(:topic, :user => @other_user)
      reply = Factory(:post, :user => @user, :topic => other_topic)
      @user.reload
      @user.posts.should =~ [post, reply]
    end

    it "could not be destroied" do
      user_id = @user.id
      lambda { @user.destroy }.should raise_error
      User.find(user_id).should be
    end

    describe "with manager premission" do
      before(:each) do
        @board = Factory(:board)
        @board.managers << @user
        @category = Factory(:category)
        @category.managers << @user
      end
      it "could get its manageable boards" do
        @user.manageable_boards.should =~ [@board]
      end
      it "could get its manageable categories" do 
        @user.manageable_categories.should =~ [@category]
      end
    end

    it "is not admin when created" do
      @user.admin?.should_not be
    end

    it "is not a manager when created" do
      @user.manager?.should_not be
    end

    it "could be set as admin" do
      @user.admin = true
      @user.save
      @user.reload
      @user.admin?.should be
    end

    it "cannot modify admin attribute by update_attributes" do
      @user.update_attributes(:admin => true)
      @user.admin?.should_not be
    end

    it "could be banned" do
      @user.banned?.should_not be
      @user.ban
      @user.reload
      @user.banned?.should be
    end

    it "could be unbanned" do
      @user.ban
      @user.reload
      @user.banned?.should be

      @user.unban
      @user.reload
      @user.banned?.should_not be
    end

    it "could edit his posts" do
      topic = Factory(:topic, :user => @user)
      post = Factory(:post, :topic => topic, :user => @user)
      @ability.should be_able_to(:update, post)
    end

    it "could not be edited by users other than its author" do
      topic = Factory(:topic, :user => @user)
      post = Factory(:post, :topic => topic, :user => @user)
      @other_user_ability.should_not be_able_to(:update, post)
    end


  end

  describe "board manager" do
    before(:each) do
      @board = Factory(:board)
      @topic = Factory(:topic, :board => @board)
      @post = Factory(:post, :topic => @topic)

      @other_board = Factory(:board)
      @other_topic = Factory(:topic, :board => @other_board)
      @other_post = Factory(:post, :topic => @other_topic)

      @manager = Factory(:user)
      @manager.manageable_boards << @board

      @ability = AdminAbility.new(@manager)
    end

    it "is treat as a manager" do
      @manager.manager?.should be
    end

    it "can manage contents under his manageable borads" do
      @ability.should be_able_to(:manage_content, @board)
      @ability.should be_able_to(:manage, @topic)
      @ability.should be_able_to(:manage, @post)
    end

    it "cannot manage other boards" do
      @ability.should_not be_able_to(:manage_content, @other_board)
      @ability.should_not be_able_to(:manage, @other_topic)
      @ability.should_not be_able_to(:manage, @other_post)
    end

  end

  describe "category manager" do
    pending
  end

  describe "admin" do
    before(:each) do
      @board = Factory(:board)
      @admin = Factory(:user, :admin => true)
    end
    
    it "is treat as a manager" do
      @admin.manager?.should be
    end
    
  end

end
