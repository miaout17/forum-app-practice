class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user

    can :update, Post do |post|
      post.user_id == user.id and post.status == "published" and post.topic.status=="published"
    end

    can :read, Topic, :status => "published"

    # if user.admin?
    #   can :manage, :all
    # else
    #   can :read, :all
    # end
  end
end

