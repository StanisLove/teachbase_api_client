class CoursesController < ApplicationController
  before_action :load_courses_and_status
  def index
    if @status == 404
      flash[:alert] = "В данный момент Teachbase недоступен. Загружена копия от #{@fall_time.strftime("%d.%m.%Y %H:%M")}."
    elsif @status == 0
      flash[:alert] = "Teachbase лежит уже #{@downtime} часов"
    end
  end

  private
    def load_courses_and_status
      status_in_db = Course.first.try(:response_status)

      if  status_in_db == 200 || status_in_db.nil?  # before request
        Course.request_and_save
        @status = Course.first.response_status # 200 or 404 after request

        if @status == 200
          @courses = Course.page(params[:page]).per(2)
        elsif @status == 404
          @fall_time = Course.first.updated_at
          @courses   = Course.where.not(course_id: 0).page(1).per(1) # without fake_course
        end
      else
        @fall_time = Course.first.updated_at
        @downtime  = ((Time.now - @fall_time)/3600).round
        @status    = @downtime > 0 ? 0 : 404
        @courses   = Course.where.not(course_id: 0).page(1).per(1) # without fake_course
      end
    end
end
