class AddIndexToResponseStatus < ActiveRecord::Migration
  def change
    add_index :courses, :response_status
  end
end
