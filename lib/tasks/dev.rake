namespace :dev do
  task :build => ['db:drop', 'db:create', 'db:migrate'] do
  end

  CATEGORY_NUM = 2
  BOARDS_PER_CATEGORY = 2
  TOPICS_PER_BOARD = 21
  POSTS_PER_TOPIC = 12

  task :fake => ['environment', 'dev:build'] do
    ActiveRecord::Base.transaction do

      CATEGORY_NUM.times { Factory(:category) }

      Category.all.each do |category|
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

