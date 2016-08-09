class Course < ActiveRecord::Base
  validates :name, :description, :owner_name, :course_id, :course_updated_at, presence: true
  mount_uploader :thumb_image, CourseImageUploader
  include ClientApi

  def self.request_and_save(response = ClientApi.get_items)
    if response.status == 200
      delete_fake_course

      response.body.each do |item|
        create_course(item) if course_does_not_exist_and_it_is_open(item)
        update_course(item) if course_updated(item)
      end

      update_all(response_status: 200)
    else
      any? ? update_all(response_status: 404, updated_at: Time.now) : create_fake_course
    end
  end


  private
    def self.create_course(item)
      create!(course_hash(item))
    end

    def self.update_course(item)
      find_by_course_id(item['course_id']).update!(course_hash(item))
    end

    def self.course_hash(item)
                      { name: item['course']['name'],
                 description: item['course']['description'],
                         url: item['apply_url'],
                  owner_name: item['course']['owner_name'],
      remote_thumb_image_url: item['course']['thumb_url'],
                  started_at: item['started_at'],
                 finished_at: item['finished_at'],
                   course_id: item['course_id'],
           course_updated_at: item['course']['updated_at'] }
    end

    def self.course_does_not_exist_and_it_is_open(item)
      !find_by_course_id(item['course_id']) && item['access_type'] == 'open'
    end

    def self.course_updated(item)
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
