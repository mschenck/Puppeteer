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
      
    if not @attributes["classes"]
      @my_classes = []
    else
      @my_classes = @attributes["classes"].join(",")
    end
    @attributes.delete("classes")
    
    @attributes.delete("_id")
    @attributes.delete("hostname")
    
  else
    @attributes = []
    @my_classes = []
  end  
  
  if not params["msg"].nil?
    @msg = params["msg"]
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
    params.delete("_rev")
    @msg = "Added"
  end

  @hostname = params["hostname"]

  # Store passed node data
  doc = JSON params
  server.put "/nodes/#{ @hostname }", doc

  redirect to "/node?id=#{@hostname}&msg=#{@msg}"
end