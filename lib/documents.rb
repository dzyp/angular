module MyApp
  class DocumentsCtrl < Sinatra::Base
    helpers Sinatra::JSON
    
    set :json_encoder, :to_json
    
    get "/.?:documentId?" do |d|      
      if not d
        return Document.all.to_a.to_json
      end
      
      begin
        document = Document.find d
        json status: 'ok',
             data: document
      rescue
        json status: 'error',
             error: 'Unable to find document with #{d}'
      end
      
    end
   
  end
end