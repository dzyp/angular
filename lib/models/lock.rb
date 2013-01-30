class Lock
  include Mongoid::Document
  
  field :lock_by, type:String
  belongs_to :document
end