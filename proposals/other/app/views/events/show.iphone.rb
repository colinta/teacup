# element(object, attribute, props) => DSL
label{@event,       :name, :background-color => "#ffffff", :font => UIFont.fontWithName("Helvetica-Bold")}
label{@event.venue, :name, :link_to => :show} # or a click handler?
