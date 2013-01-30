class Document
  include Mongoid::Document
  
  field :name, type:String
  
  has_one :entity
  has_many :locks
end