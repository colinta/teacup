text_field{@event, :name}
text_field{@event, :price}
button("Save?").on(:press) do |btn|
  alert("Slide to save the event")
end.on(:slide) do |btn|
  update(@event.id)
end