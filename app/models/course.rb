class Course < ActiveRecord::Base
  validates :name, :description, :owner_name, presence: true

end
