module MyApp
  class LocksCtrl < Sinatra::Base
    include Sinatra::JSON
    set :json_encoder, :to_json
    
    get "/.?:documentId?" do |d|
      authenticate!
      
      if not d
        return Lock.all.to_a.to_json
      end
      
      begin
        document = Document.find(d)
        return document.locks.to_a.to_json
      rescue Exception => e
        p e.message
        p e.backtrace
        json status: 'error',
             error: 'Unable to fetch locks for key: #{d}'
      end
    end
    
  end
end