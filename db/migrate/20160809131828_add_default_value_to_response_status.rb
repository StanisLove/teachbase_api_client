class AddDefaultValueToResponseStatus < ActiveRecord::Migration
  def change
    change_column :courses, :response_status, :integer, default: 200
  end
end
