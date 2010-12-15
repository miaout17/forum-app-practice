class Ability
  include CanCan::Ability

  def initialize(user)
    raise

    user ||= User.new # guest user
    can :update, Post, :user_id => user.id

    # if user.admin?
    #   can :manage, :all
    # else
    #   can :read, :all
    # end
  end
end

