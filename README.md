# Chaskiq

### A Rails engine to send newsletters.

<p>The <i><b>Chasquis</b></i> (also <i><b>Chaskiq (Quechua word)</b></i>) were agile and highly trained <a title="Running" href="/wiki/Running">runners</a> that delivered messages,<sup class="reference" id="cite_ref-1"><a href="#cite_note-1"><span>[</span>1<span>]</span></a></sup> royal delicacies such as fish<sup class="reference" id="cite_ref-2"><a href="#cite_note-2"><span>[</span>2<span>]</span></a></sup> and other objects throughout the <a title="Inca Empire" href="/wiki/Inca_Empire">Inca Empire</a>, principally in the service of the <a title="Sapa Inca" href="/wiki/Sapa_Inca">Sapa Inca</a>.</p>

### Motivation.

I really don't like the idea to pay ~50USD to send a simple newsletter, I find that commertial alternatives are really awesome, but those solutions have nothing that OS community can't achieve.

### How it works.

Chaskiq will work with any email setting but is recommended to use Amazon SES+SNS in order to get the bounce and spam detection features.

#### Features:

+ Email template editor out of the box.
+ Mustache tags enables to use variables in templates.
+ Tracks opens and clics.
+ Tracks Bounces and Complaints (via AWS SNS).
+ Displays reports on:
  + % of deliveries.
  + clicks , opens , bounces, complaints.
  + Detail list off who opens, clicks, bounces & complaints.
+ Reusable templates.
+ Reusable email lists.


### How to install:

Use chaskiq as a gem in a rails project.

+ gem 'chaskiq' in your gemfile
+ rake chaskiq:migrations:install
+ rake db:migrate
+ add routes:
  ```mount Chaskiq::Engine => "/"```

+ config/initializers/active_job.rb
  ```ActiveJob::Base.queue_adapter = :sidekiq```

### Secure system:

you can use any user system just configue Chaskiq authentication method for controllers.

assuming you are using device, to protect the admin paths you will use the device's auth method for controllers as is.

config/initializers/chaskiq.rb

```ruby
Chaskiq::Config.setup do |config|
  config.authentication_method = :authenticate_user!
end
```


### Upload to Heroku

You can use chaskiq in any VPS server, the required services are Redis and mysql/postgres. And you have to run sidekiq side by side with your app server.

in Heroku for example you will use to services, declared in your Procfile.

```ruby
worker: bundle exec sidekiq -q default -q mailers
web: bundle exec rainbows -c config/rainbows.rb -p $PORT
```
and add the redis_to_go addon.

config/rainbows.rb
```ruby
worker_processes 3
timeout 30
preload_app true

Rainbows! do
  use :EventMachine
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end
```

config/initializers/sidekiq.rb
```ruby
require "redis"
require "sidekiq"

if Rails.env.production?
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(url: ENV["REDISTOGO_URL"])


  Sidekiq.configure_client do |config|
    config.redis = {url: ENV["REDISTOGO_URL"]}
    #Sidekiq::RedisConnection.create(:namespace => "resque")
  end

  Sidekiq.configure_server do |config|
    config.redis = {url: ENV["REDISTOGO_URL"]}
    #Sidekiq::RedisConnection.create(:namespace => "resque")
  end

end
```


# TODO:

+ buscadores.
+ editor ta casi , pero cambiar nombres apretar estilos.
+ apretar estilos.
+ mas reportes.



Miguel Michelson Martinez.