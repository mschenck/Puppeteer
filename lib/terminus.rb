require './lib/couch'
require 'json'

get '/terminus/' do
  server = Couch::Server.new("localhost", "5984")

  # existing Node
  if not params["id"].nil?
    @hostname = params["id"]
    json = server.get("/nodes/#{ @hostname }").body
    @attributes = JSON.parse(json)
    
    @classes = @attributes["classes"]
    @attributes.delete("classes")
    
    @attributes.delete("_rev")
    @attributes.delete("_id")
    @attributes.delete("hostname")
    
    node = {}
    
    node["classes"] = @classes
    node["parameters"] = []
    
    @attributes.each do |attr|
      key = attr[0]
      value = attr[1]
      
      # Convert arrays
      if value.match('^\[')
        val_array = value.gsub(/[\[\]]/,'').gsub(/, +/,',').split(',')
        value = val_array
      else
        # convert hashes
        if value.match('^\{')
          #val_hash = value.gsub(/[\{\}]/,'').gsub(/ +\=> +/,':').gsub(/, +/,',').split(',')
          #val_hash[0] = ":#{val_hash[0]}"
          #value = val_hash
          value = eval(value)
        end
      end
      
      node["parameters"].push( {key => value} )
    end
    
    yaml = node.to_yaml
    
    return yaml
  else
    return ''
  end
end