namespace :test do
  desc "Run tests for Secretary"
  task :secretary do
    $stdout.puts %x{bundle exec rspec --tty lib/secretary/spec}
  end

  desc "Run all library tests"
  task :lib => [:secretary]
end
