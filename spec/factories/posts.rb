# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :post do |f|
  f.sequence(:content) { Faker::Lorem.sentence }
  f.association(:topic)
end
