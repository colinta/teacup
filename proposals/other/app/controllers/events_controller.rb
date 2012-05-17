class EventsController < Controller

  # Idea: Need to think about this more, but in lue of generators, we could have 
  # over-rideable defaults based on a responds_to/actions
  # Idea: This would also configure what actions a controller can respond to / route to (do we need routes?)
  responds_to :only => [:new, :create, :edit, :update, :destroy, :index, :show] # default options

  def show(id)
    @event = Event.find(id)
    render :show
  end

  def edit(id)
    @event = Event.find(id)
  end

  def update(id)
    # Note: How would this conflict with the previously set @event, should something be passed? augment params?
    @event = Event.find(id)
    @event.update_attributes(
      # 1. data from the current/old view?
      # 2. autosave was false
      :price => self.view.price
    )
    # render :edit # Idea: (self.view is loaded)
  end

end
