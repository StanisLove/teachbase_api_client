class CoursesController < ApplicationController
  before_action :load_courses_and_status
  def index
    if @status == 404 && @downtime == 0
      flash[:alert] = "В данный момент Teachbase недоступен. Загружена копия от #{@fall_time.strftime("%d.%m.%Y %H:%M")}."
    elsif @status == 404 && @downtime > 0
      flash[:alert] = "Teachbase лежит уже #{@downtime} часов"
    end
  end

  private
    def load_courses_and_status
      @status = Course.status

        if @status == 200
          @courses = Course.page(params[:page]).per(2)
        else
          @courses = Course.where.not(course_id: 0).page(1).per(1)
          @fall_time = Course.first.updated_at
          @downtime  = ((Time.now - @fall_time)/3600).round
        end
    end
end
