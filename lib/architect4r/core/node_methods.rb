module Architect4r
  module Core
    module NodeMethods
      extend ActiveSupport::Concern
      
      def create_node(properties)
        # Send request
        response = Typhoeus::Request.post(prepend_base_url('/node'), 
          :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
          :body => properties.to_json)
        
        # Evaluate response
        response.code == 201 ? JSON.parse(response.body) : nil
      end
      
      def get_node(id)
        # Example response for a node
        # extensions: {}
        # 
        # paged_traverse: http://localhost:7475/db/data/node/0/paged/traverse/{returnType}{?pageSize,leaseTime}
        # self: http://localhost:7475/db/data/node/0
        # property: http://localhost:7475/db/data/node/0/properties/{key}
        # data: {}
        # 
        # incoming_typed_relationships: http://localhost:7475/db/data/node/0/relationships/in/{-list|&|types}
        # outgoing_typed_relationships: http://localhost:7475/db/data/node/0/relationships/out/{-list|&|types}
        # incoming_relationships: http://localhost:7475/db/data/node/0/relationships/in
        # all_relationships: http://localhost:7475/db/data/node/0/relationships/all
        # create_relationship: http://localhost:7475/db/data/node/0/relationships
        # traverse: http://localhost:7475/db/data/node/0/traverse/{returnType}
        # properties: http://localhost:7475/db/data/node/0/properties
        # all_typed_relationships: http://localhost:7475/db/data/node/0/relationships/all/{-list|&|types}
        # outgoing_relationships: http://localhost:7475/db/data/node/0/relationships/out
        
        # Handle cases where id might be a url
        
        response = Typhoeus::Request.get(node_url(id), :headers => { 'Accept' => 'application/json' })
        response.code == 200 ? JSON.parse(response.body) : nil
      end

      def update_node(id, properties)
        # Handle urls
        url = id.to_i == 0 ? id : node_url(id)

        # Append the properties
        url += "/properties"

        response = Typhoeus::Request.put(url, 
          :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
          :body => properties.to_json)
        response.code == 204 ? true : false
      end
      
      def delete_node(id)
        # Delete all relationships
        get_node_relationships(id, :all).each do |rel|
          delete_relationship(rel)
        end
        
        # Delete node itself
        response = Typhoeus::Request.delete(node_url(id), :headers => { 'Accept' => 'application/json' })
        response.code == 204 ? true : false
      end
      
      def root
        get_node(get('/')['reference_node'])
      end
      
      def node_id(input)
        node_url(input).match(/node\/(\d+)$/i)[1].to_i
      end
      
    end
  end
end