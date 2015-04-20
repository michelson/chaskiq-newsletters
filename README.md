# Chaskiq

### A Rails engine to send newsletters.

![](./chaskiq-admin.png)


<p>The <i><b>Chasquis</b></i> (also <i><b>Chaskiq (Quechua word)</b></i>) were agile and highly trained runners that delivered messages royal delicacies such as fish and other objects throughout the Inca Empire, principally in the service of the Sapa Inca.</p>

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
+ Mailchimp like template editor.


### How to install:

Use chaskiq as a gem in a rails project.

+ gem 'chaskiq' in your gemfile and execute bundle install
+ rails generate chaskiq:install (will add an initializer , route & migrations)
+ rake db:migrate

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

read more about heroku, vps installs, amazon integration and more in our wiki page https://github.com/michelson/chaskiq/wiki

# TODO:

+ search items.
+ improve mail editor.
+ styles on panel.
+ more reportery.
+ scheduled deliveries.
+ send to list segments.



Miguel Michelson Martinez.