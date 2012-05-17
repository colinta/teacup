class Event < Model

  # Idea: By default the endpoint is considered a local Sqllite store, see db/README.md for more information.
  #
  # endpoint nil                  # uses sqlite, not required
  #
  # endpoint "http://example.com" # simple configuration
  #
  # # more advanced confiruations delegating to something, in this case the AppDelegate for a current_user
  # endpoint lambda { 
  #   "https://#{app.current_user.name}:pass@example.com" 
  # }

end