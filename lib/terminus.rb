require './lib/couch'
require 'json'

def try_string_to_hash(value)
  value_array = []
  
  # Load up array if possible
  value.scan(/"(?:[^"\\]|\\.)*"/) { |array_element|
    array_element.gsub!(/\"/,"")
    value_array.push(array_element)
  }
  
  # If array, lock for hash_values
  value_hash = {}
  value_array.each_index do |key|
    if value_array[key].match(/(.)* => (.)*/)
      new_key, new_val = value_array[key].split(/[ :]=>[ :]/)
      value_hash[new_key] = new_val
    end
  end
  
  if value_hash.length > 1
    return value_hash
  elsif value_array.length > 1
    return value_array
  end

  value
end


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

      value = try_string_to_hash value
              
      node["parameters"].push( {key => value} )
    end
    
    yaml = node.to_yaml
    
    return yaml
  else
    return ''
  end
end