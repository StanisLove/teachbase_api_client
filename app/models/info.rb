class Info
#  1. handle status
#  2. save course
#  3. update course
#
  attr_accessor :courses, :status, :fall_time, :downtime, :message

  def initialize
    @status = 200
  end

  def load
    if Course.find_by_response_status(404)
      @status    = 404
      @fall_time = Course.find_by_response_status(404).updated_at
      @downtime  = ((Time.now - @fall_time)/3600).round

      @message = if @downtime == 0
        "В данный момент Teachbase недоступен. Загружена копия от #{@fall_time.strftime("%d.%m.%Y %H:%M")}."
      elsif @downtime > 0
        "Teachbase лежит уже #{@downtime} часов"
      end
    else
      ResponseHandler.request_and_save
    end
    @courses = Course.where.not(course_id: 0)
  end

end
