namespace :dev do
  
  desc "Rebuild the database and create seed data"
  task :build => ['db:drop', 'db:create', 'db:migrate', 'db:seed'] do
  end

  CATEGORY_NUM = 2
  BOARDS_PER_CATEGORY = 2
  TOPICS_PER_BOARD = 10
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

  desc "Generate fake data"
  task :fake => ['environment'] do
    ActiveRecord::Base.transaction do 
      puts "Generating Categories..."

      2.times { Factory(:category) }

      subcategories = []

      # create_hierarchical_categories( Factory(:category), 2, 2)
      Category.all.each do |category|
        3.times do
          subcategory = Factory(:category, :parent => category)
          subcategories << subcategory
        end
      end

      puts "Generating Boards..."

      subcategories.each do |category|
        BOARDS_PER_CATEGORY.times { Factory(:board, :category => category) }
      end

      puts "Generating Topics..."

      all_boards = Board.all
      TOPICS_PER_BOARD.times do
        all_boards.each do |board|
          Factory(:topic, :board => board)
        end
      end

      puts "Generating Posts..."

      Topic.all.each do |topic|
        POSTS_PER_TOPIC.times do
          Factory(:post, :topic => topic)
        end
      end

      user = Factory(:user, :email => "tester@mail.com", :password=>"123456")
      puts "Generated a authenticated user(email=#{user.email}, password=#{user.password})"
    end
  end

  desc "Run dev:build and dev:fake"
  task :refake => ['dev:build', 'dev:fake'] do
  end
end
