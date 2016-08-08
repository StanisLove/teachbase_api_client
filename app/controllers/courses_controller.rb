class CoursesController < ApplicationController
  def index
    Course.save_into_db
    @courses = Course.all
  end

end
