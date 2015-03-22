worker_processes 3
timeout 30
preload_app true

Rainbows! do
  use :EventMachine
end

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end