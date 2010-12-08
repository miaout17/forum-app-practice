# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :topic do |f|
  f.sequence(:title) { Faker::Lorem.sentence }
  f.association :board
end
