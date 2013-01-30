module MyApp
  
  class EntitiesCtrl < Sinatra::Base
    
    get "/.?:entityId?" do |e|
      authenticate!
      
      if not e
        return Entity.all.to_a.to_json
      end
      
      begin
        entity = Entity.find(e)
        json status: 'ok',
             data: entity
      rescue
        json status: 'error',
             data: 'Error retrieving entity with key: #{e}'
      end
    end
    
  end
  
end