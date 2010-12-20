class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user

    can :update, Post, :user_id => user.id, :status => "published" do |post|
      post.topic.status=="published"
    end

    can :read, Topic, :status => "published"

    # if user.admin?
    #   can :manage, :all
    # else
    #   can :read, :all
    # end
  end
end

