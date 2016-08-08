class AddResponseStatusToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :response_status, :integer
  end
end
