module MyApp
  class AppCtlr < Sinatra::Base
    set :views, Proc.new { File.join(root, "../views") }
    
    get "/" do
      haml :index
    end
  
  end
end