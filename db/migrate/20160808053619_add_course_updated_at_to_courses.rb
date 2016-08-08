class AddCourseUpdatedAtToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_updated_at, :datetime, null: false
  end
end
