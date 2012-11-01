def debug_this
  $debug = true
  begin  
    yield
  ensure
    $debug = false
  end
end

def debug(str)
  puts str if $debug
end
