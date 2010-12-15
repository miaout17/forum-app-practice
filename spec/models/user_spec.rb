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

  describe "instance" do

    before(:each) do
      @user = Factory(:user)
      @another_user = Factory(:user)
    end

    it "could get its topics" do
      topic = Factory(:topic, :user => @user)
      @user.reload
      @user.topics.should =~ [topic]
    end

    it "could get its posts" do
      topic = Factory(:topic, :user => @user)
      post = Factory(:post, :user => @user, :topic => topic)
      other_topic = Factory(:topic, :user => @another_user)
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

    pending "admin.."
    pending "could be banned"

  end

end
