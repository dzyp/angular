class Post
  include Mongoid::Document
  
  field :email, type: String
  field :title, type: String
end