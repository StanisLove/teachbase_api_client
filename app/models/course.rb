class Course < ActiveRecord::Base
  validates :name, :description, :owner_name, :course_id, :course_updated_at, presence: true
  mount_uploader :thumb_image, CourseImageUploader

  private

    def self.updated?(item)
      find_by_course_id(item['course_id']) &&
      find_by_course_id(item['course_id']).course_updated_at != item['course']['updated_at']
    end

    def self.create_fake_course
      create(name: 'fake', description: 'fake', owner_name: 'fake',
             course_id: 0, course_updated_at: Time.now, response_status: 404)
    end

    def self.delete_fake_course
      find_by_course_id(0).try(:delete)
    end

end
