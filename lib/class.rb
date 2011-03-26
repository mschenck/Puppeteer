require './lib/couch'

get '/classes' do
  server = Couch::Server.new("localhost", "5984")

  json = server.get("/classes/_all_docs").body
  @classes = []
  JSON.parse(json)["rows"].each do |class_obj|
    @classes.push(class_obj["id"])
  end

  @page = "Classes"
  haml :classes
end

get '/class' do

  server = Couch::Server.new("localhost", "5984")

  # existing Class
  if not params["id"].nil?
    @classname = params["id"]
    json = server.get("/classes/#{ @classname }").body
    @attributes = JSON.parse(json)
    
    @rev = @attributes["_rev"]
    @attributes.delete("_rev")
    @attributes.delete("_id")
    @attributes.delete("classname")
  else
    @attributes = []
  end  

  if not params["msg"].nil?
    @msg = params["msg"]
  end


  @page = "Manage class"
  haml :edit_class
end

post '/class' do

  server = Couch::Server.new("localhost", "5984")

  # Class add or update?
  if params["_rev"] != ""
    @msg = "Updated"
  else
    params.delete("_rev")
    @msg = "Added"
  end

  @classname = params["classname"]

  # Store passed class data
  doc = JSON params
  server.put "/classes/#{ @classname }", doc
  
  redirect to "/class?id=#{@classname}&msg=#{@msg}"
end