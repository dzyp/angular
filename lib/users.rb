module MyApp
  class UsersCtlr < Sinatra::Base
    helpers Sinatra::JSON

    post "/" do
      @user = User.new(json_data['user'])
      if @user.save
        session[:user_id] = @user.id
        json status: 'ok' 
      else
        json status: 'error', 
             error: @user.errors.full_messages.to_sentence
      end
    end

    get "/" do
      authenticate!
      json status: 'ok',
           user: current_user.json_public
    end

    get "/status" do
      if signed_in?
        json status: 'ok'
      else
        json status: 'not signed in'
      end
    end
    
    put "/access_token" do
      authenticate!
      current_user.update_token
      json current_user.json_public
    end
    
    put "/password" do
      authenticate!
      if current_user.update_password(json_data['user'])
        json status: 'ok'
      else
        json status: 'error', 
             error: current_user.errors.full_messages.to_sentence
      end
    end

    post '/session' do
      user = User.authenticate(json_data['email'], json_data['password'])
      if user
        session[:user_id] = user.id
        json status: 'ok' 
      else
        json status: 'error', 
             error: "Invalid email or password"
      end
    end
    
    delete '/session' do
      authenticate!
      session[:user_id] = nil
      json status: 'ok'
    end
    
  end
end
