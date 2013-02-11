namespace :test do
  desc "Run tests for Secretary"
  task :secretary do
    $stdout.puts %x{bundle exec rspec --tty lib/secretary/spec}
  end
  
  desc "Run tests for Outpost"
  task :outpost do
    $stdout.puts %x{bundle exec rspec --tty lib/outpost/spec}
  end
  task :ar => :outpost
  
  desc "Run all library tests"
  task :lib => [ :secretary, :outpost ]
end
