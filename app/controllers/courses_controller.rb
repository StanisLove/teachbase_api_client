class CoursesController < ApplicationController
  def index
    Course.save_into_db
    @courses = Course.all.page(params[:page]).per(1)
  end

end
