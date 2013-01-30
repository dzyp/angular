module MyApp
  class Api < Sinatra::Base

    get "/ping" do
      json status: 'ok'
    end

  end
end