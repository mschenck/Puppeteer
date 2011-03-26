require './lib/couch'

get '/nodes' do
  server = Couch::Server.new("localhost", "5984")

  json = server.get("/nodes/_all_docs").body
  @nodes = []
  JSON.parse(json)["rows"].each do |node|
    @nodes.push(node["id"])
  end

  @page = "Nodes"
  haml :nodes
end

get '/node' do
  server = Couch::Server.new("localhost", "5984")

  # existing Node
  if not params["id"].nil?
    @hostname = params["id"]
    json = server.get("/nodes/#{ @hostname }").body
    @attributes = JSON.parse(json)
    @rev = @attributes["_rev"]
    @attributes.delete("_rev")
    @attributes.delete("_id")
    @attributes.delete("hostname")
  else
    @attributes = []
  end  

  @page = "Manage node"
  haml :edit_node
end

post '/node' do 

  server = Couch::Server.new("localhost", "5984")

  # Node add or update?
  if params["_rev"] != ""
    json = server.get("/nodes/#{ @hostname }").body
    @msg = "Updated"
  else
    params.delete("_rev")
    @msg = "Added"
  end

  @hostname = params["hostname"]

  # Store passed node data
  doc = JSON params
  server.put "/nodes/#{ @hostname }", doc

  @page = "Node changed"
  haml :node_changed
end