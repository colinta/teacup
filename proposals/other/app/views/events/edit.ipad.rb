text_field{@event, :name,  :autosave => true}
text_field{@event, :price, :autosave => false}

button("Save?").on(:press) do |btn|
  alert("Slide to save the event")
end.on(:slide) do |btn|
  update(@event.id) # invokes to controller or use @controller?
end