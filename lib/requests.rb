module MyApp
  class RequestsCtrl < Sinatra::Base
    helpers Sinatra::JSON
    
    set :json_encoder, :to_json
    
    get "/.?:requestId?" do |r|
      authenticate!
      Request.all.to_a.to_json
    end
    
    post "/" do
      authenticate!
      @request = Request.new(json_data['request'])
      p @request
      if @request.save
        json status: 'ok',
             data: @request
      else
        json status: 'error',
             error: @request.errors.full_messages.to_sentence
      end
    end
    
  end
end