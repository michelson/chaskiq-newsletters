# desc "Explaining what the task does"
# task :chaskiq do
#   # Task goes here
# end
namespace :chaskiq do
  task update_subs: :environment do
    Chaskiq::Subscriber.all.each do |s|
      sub = s.subscriptions.new
      sub.list_id = s.list_id
      sub.state = s.state
      sub.save
    end
  end
end