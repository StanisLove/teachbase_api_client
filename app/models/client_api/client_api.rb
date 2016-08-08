module ClientApi
  def self.access_token
    conn = Faraday.new(url: 'http://s1.teachbase.ru') do |faraday|
      faraday.request :url_encoded
      faraday.response :oj
      faraday.adapter Faraday.default_adapter
    end


    response = conn.post '/oauth/token', {
      client_id: Rails.application.secrets.client_key,
      client_secret: Rails.application.secrets.secret_key,
      grant_type: 'client_credentials'
    }

    return response.body["access_token"]
  end

  def self.get_items
    conn = Faraday.new(url: 'http://s1.teachbase.ru') do |faraday|
      faraday.request :oauth2, access_token
      faraday.response :oj
      faraday.adapter Faraday.default_adapter
    end

    @items = (conn.get '/endpoint/v1/course_sessions',
      { 'Authorization' => "Bearer #{access_token}" }).body
  end
end
