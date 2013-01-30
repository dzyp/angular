module MyApp
  class TestCtrl < Sinatra::Base
    
    get "/entity" do
      authenticate!
      name = (0...8).map{65.+(rand(26)).chr}.join
      entity = Entity.new({
        :name => name
      })
      document = Document.new({
        :name => name
      })
      document.save
      entity.save
      document.entity = entity
      document.save
      3.times do
        lock = Lock.new({
          :locked_by => current_user.email
        })
        document.locks.push(lock)
        document.save
      end
      
      'done'
    end
    
  end
end