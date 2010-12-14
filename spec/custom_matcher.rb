module CustomMatchers

  RSpec::Matchers.define :be_able_to do |action, object|
    match do |user|
      ability = Ability.new(user)
      ability.can?(action,object)
    end

    failure_message_for_should do |user|
      "expected the user #{user} able to #{action} #{object}"
    end

    failure_message_for_should_not do |user|
      "expected the user #{user} unable to #{action} #{object}"
    end
  end

end
