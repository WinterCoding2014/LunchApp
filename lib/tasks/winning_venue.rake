namespace :winner do
  desc "update the view to show the winner when it's time"
  task :winner_task => :environment do
    puts "now showing the winner"
    # NewFeed.update
    puts "done"
  end
end