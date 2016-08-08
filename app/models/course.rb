class Course < ActiveRecord::Base
  validates :name, :description, :owner_name, :course_id, :course_updated_at, presence: true
  include ClientApi

  def self.save_into_db
    ClientApi.get_items.each do |item|
      if Course.find_by_course_id(item['course']['id']).try(:course_updated_at) != item['course']['updated_at'] &&
        item['access_type'] == 'open'
        create!(
                       name: item['course']['name'],
                description: item['course']['description'],
                        url: item['apply_url'],
                 owner_name: item['course']['owner_name'],
                  thumb_url: item['course']['thumb_url'],
                 started_at: item['started_at'],
                finished_at: item['finished_at'],
                  course_id: item['course_id'],
          course_updated_at: item['course']['updated_at']
        )
      end
    end
  end
end
