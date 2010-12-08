namespace :dev do
  task :build => ['db:drop', 'db:create', 'db:migrate'] do
  end

  task :fake => ['environment', 'dev:build'] do
    ActiveRecord::Base.transaction do
      2.times { Factory(:board) }
    end
  end
end

