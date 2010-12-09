namespace :dev do
  task :build => ['db:drop', 'db:create', 'db:migrate'] do
  end

  CATEGORY_NUM = 2
  BOARDS_PER_CATEGORY = 2
  TOPICS_PER_BOARD = 21
  POSTS_PER_TOPIC = 12

  def create_hierarchical_categories(parent, num, level)
    return unless level > 0
    num.times do
      new_category = Category.new
      new_category.name = Faker::Lorem.sentence
      new_category.parent_id = parent.id
      new_category.save

      create_hierarchical_categories(new_category, num, level-1)
    end
  end

  task :fake => ['environment', 'dev:build'] do

    ActiveRecord::Base.transaction do 
      2.times { Factory(:category) }

      subcategories = []

      # create_hierarchical_categories( Factory(:category), 2, 2)
      Category.all.each do |category|
        3.times do
          subcategory = Factory(:category, :parent => category)
          subcategories << subcategory
        end
      end

      subcategories.each do |category|
        BOARDS_PER_CATEGORY.times { Factory(:board, :category => category) }
      end

      Board.all.each do |board|
        TOPICS_PER_BOARD.times do
          Factory(:topic, :board => board)
        end
      end

      Topic.all.each do |topic|
        POSTS_PER_TOPIC.times do
          Factory(:post, :topic => topic)
        end
      end
    end

  end
end

