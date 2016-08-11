class ApiClient

  def post # authorization
    conn = connection(:url_encoded)

    response = conn.post '/oauth/token', {
      client_id: Rails.application.secrets.client_key,
      client_secret: Rails.application.secrets.secret_key,
      grant_type: 'client_credentials'
    }

    response.body["access_token"]
  end

  def get(access_token = self.post) # data
    conn = connection(:oauth2, access_token)

    return conn.get '/endpoint/v1/course_sessions',
      { 'Authorization' => "Bearer #{access_token}" }
  end

  private
    def connection(request, params = [])
      Faraday.new(url: 'http://s1.teachbase.ru') do |faraday|
        faraday.request(request, *params)
        faraday.response :oj
        faraday.adapter Faraday.default_adapter
      end
    end
end
