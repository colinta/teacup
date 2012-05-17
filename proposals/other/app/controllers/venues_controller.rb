class VenuesController < Controller
  # Idea: We may want to force some kind of nesting in controller
  belongs_to :event
end