class CoursesController < ApplicationController
  before_action :get_courses
  def index
  end

  private
    def access_token
      conn = Faraday.new(url: 'http://s1.teachbase.ru') do |faraday|
        faraday.request :url_encoded
        faraday.response :oj
        faraday.adapter Faraday.default_adapter
      end

      client_key = 'f2289ec45da71c85f7841f3760bc0b7426e18ca63f3167c00ed77643b199d39e'
      secret_key = 'bb7966f39349a2406c6d428f134c52bc71d4e4c53565ddb97efd7fa078a97090'

      response = conn.post '/oauth/token', {
        client_id: client_key,
        client_secret: secret_key,
        grant_type: 'client_credentials'
      }

      return response.body["access_token"]
    end

    def get_courses
      conn = Faraday.new(url: 'http://s1.teachbase.ru') do |faraday|
        faraday.request :oauth2, access_token
        faraday.response :oj
        faraday.adapter Faraday.default_adapter
      end

      @courses = conn.get '/endpoint/v1/course_sessions',
        { 'Authorization' => "Bearer #{access_token}" }

    end
end
