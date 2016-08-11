class CoursesController < ApplicationController
  before_action :load_courses_and_status

  def index
    if @info.status == 200
      @courses = @info.courses.page(params[:page]).per(2)
    else
      @courses = @info.courses.page(1).per(1)
      flash[:alert] = @info.message
    end
  end

  private
    def load_courses_and_status
      @info = Info.new
      @info.load
    end
end
