# Railsifiying mobile development

** This is a rough idea, which may have lots of holes, please comment on it, post issues, or fork. ** 


It's time we take control of iOS app development, because it's clunky, 
slow, not obvious and because we love Ruby & Rails.

We can't have "just" styling, it's not a full solution we need a framework now
more then ever.

With that said, I believe Rails provides a solid MVC. It can help hide or augment
may of the typical problems with iOS development.


Directory structure:

    .teacup
    |____app
    | |____config
    | | |____application.rb
    | | |____boot.rb
    | | |____initializers
    | | | |____twitter.rb
    | |____controllers
    | | |____events_controller.rb
    | | |____venues_controller.rb
    | |____db
    | | |____migrations
    | | | |____20120514201043_create_events.rb
    | | | |____20120514201044_add_price_to_events.rb
    | | | |____20120514201045_create_venues.rb
    | | |____README.md
    | | |____schema.rb
    | |____models
    | | |____event.rb
    | | |____venue.rb
    | |____views
    | | |____events
    | | | |____edit.ipad.rb
    | | | |____edit.iphone.rb
    | | | |____show.ipad.rb
    | | | |____show.iphone.rb
    | | |____venues
    |____README.md