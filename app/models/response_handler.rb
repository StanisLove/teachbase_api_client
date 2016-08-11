class ResponseHandler
  def self.request_and_save(response = ApiClient.new.get)
    if response.status == 200
      Course.delete_fake_course

      response.body.each do |item|
        course = Course.find_by_course_id(item['course_id'])

        Course.create!(course_hash(item)) if course.nil? && item['access_type'] == 'open'
        course.update!(course_hash(item)) if Course.updated?(item)
      end

      Course.where.not(response_status: 200).update_all(response_status: 200)
    else
      Course.any? ? Course.update_all(response_status: 404, updated_at: Time.now) : Course.create_fake_course
    end
  end

  private
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
end
