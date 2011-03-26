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

  classes_json = server.get("/classes/_all_docs").body
  @classes = []
  JSON.parse(classes_json)["rows"].each do |class_obj|
    @classes.push(class_obj["id"])
  end

  # existing Node
  if not params["id"].nil?
    @hostname = params["id"]
    json = server.get("/nodes/#{ @hostname }").body
    @attributes = JSON.parse(json)
    
    @rev = @attributes["_rev"]
    @attributes.delete("_rev")
    
    @my_classes = @attributes["classes"]
    
    if not @my_classes
      @my_classes = []
    end
    @attributes.delete("classes")
    
    @attributes.delete("_id")
    @attributes.delete("hostname")
    
  else
    @attributes = []
    @my_classes = []
  end  

  @page = "Manage node"
  haml :edit_node
end

post '/node' do 

  server = Couch::Server.new("localhost", "5984")

  # Node add or update?
  if params["_rev"] != ""
    @msg = "Updated"
  else
    @msg = "Added"
  end

  @hostname = params["hostname"]

  # Store passed node data
  doc = JSON params
  server.put "/nodes/#{ @hostname }", doc

  @page = "Node changed"
  haml :node_changed
end