class AdminAbility
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
      return
    end

    manageable_board_ids = user.manageable_boards.map { |b| b.id }

    user.manageable_categories.map do |category| 
      board_ids = category.descendant_boards.map { |b| b.id }
      manageable_board_ids.concat(board_ids)
    end

    manageable_board_ids.uniq!

    unless manageable_board_ids.empty?
      can :manage_content, Board, :id => manageable_board_ids
    end

    can :manage, Topic do |topic|
      can? :manage_content, topic.board
    end

    can :manage, Post do |post|
      can? :manage_content, post.topic.board
    end

    # TODO: board/category manager


  end
end

