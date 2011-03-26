require './lib/couch'
require 'json'

get '/terminus/' do
  server = Couch::Server.new("localhost", "5984")

  # existing Node
  if not params["id"].nil?
    @hostname = params["id"]
    json = server.get("/nodes/#{ @hostname }").body
    @attributes = JSON.parse(json)
    @attributes.delete("_rev")
    @attributes.delete("_id")
    @attributes.delete("hostname")
    
    node = {}
    node["parameters"] = @attributes
    
    yaml = node.to_yaml
    
    return yaml
  else
    return ''
  end
end