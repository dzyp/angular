class Entity
  include Mongoid::Document
  
  field :name, type: String
  
  belongs_to :document
end