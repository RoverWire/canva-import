namespace :test do
  desc 'This is a test task'
  task :ping do
    puts 'Ping executed!'
  end

  task :pong do
    puts 'Pong executed!'
  end
end
