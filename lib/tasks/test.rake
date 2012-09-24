namespace :test do
  desc "Run tests for Secretary"
  task :secretary do
    $stdout.puts %x{bundle exec rspec --tty lib/secretary/spec}
  end
  
  desc "Run tests for AdminResource"
  task :admin_resource do
    $stdout.puts %x{bundle exec rspec --tty lib/admin_resource/spec}
  end
  task :ar => :admin_resource
  
  desc "Run all library tests"
  task :lib => [ :secretary, :admin_resource ]  
end
