# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  # Omit E-mail Confirmation
  f.sequence(:email) { Faker::Internet.email }
  f.password "12345678" #must be longer than 6 chars
  f.sequence(:name) { Faker::Name.name }
  f.sequence(:confirmed_at) { Time.now }
end

