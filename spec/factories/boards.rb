# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :board do |f|
  f.sequence(:name) { Faker::Name.name }
  f.association(:category)
end
