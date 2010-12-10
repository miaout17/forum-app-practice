# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :attachment do |f|
  f.sequence(:data) do
    File.new(Rails.root + 'public/images/rails.png')
  end
end
