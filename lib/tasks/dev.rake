namespace :dev do
  task :build => ['db:drop', 'db:create', 'db:migrate'] do
  end

  BOARD_NUM = 2
  TOPIC_NUM = 21
  POST_NUM = 23

  task :fake => ['environment', 'dev:build'] do
    ActiveRecord::Base.transaction do

      BOARD_NUM.times { Factory(:board) }

      Board.all.each do |board|
        TOPIC_NUM.times do
          Factory(:topic, :board => board)
        end
      end

      Topic.all.each do |topic|
        POST_NUM.times do
          Factory(:post, :topic => topic)
        end
      end

    end
  end
end

