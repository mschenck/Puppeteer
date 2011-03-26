#!/usr/bin/ruby -rubygems

require './lib/couch'

def check_create(db="")
  server = Couch::Server.new("localhost", "5984")
  
  puts server.get("/" + db + "/", "")
  
  # server.put("/ + db + /", "")
  
end


check_create("classes")
check_create("/nodes/")
