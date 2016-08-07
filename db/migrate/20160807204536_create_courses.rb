class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string   :name,        null: false
      t.string   :description, null: false
      t.string   :url
      t.string   :owner_name,  null: false
      t.string   :thumb_url
      t.boolean  :private
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps null: false
    end
  end
end
