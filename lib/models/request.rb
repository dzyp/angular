class Request
  include Mongoid::Document
  
  field :title, type: String
end