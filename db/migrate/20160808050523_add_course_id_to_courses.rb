class AddCourseIdToCourses < ActiveRecord::Migration
  def change
    add_column    :courses, :course_id, :integer, null: false
    add_index     :courses, :course_id
    change_column :courses, :private, :boolean, default: false
  end
end
