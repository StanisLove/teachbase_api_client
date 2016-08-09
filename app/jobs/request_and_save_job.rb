class RequestAndSaveJob < ActiveJob::Base
  queue_as :default

  def perform
    Course.request_and_save(ClientApi.get_items) if Course.find_by_response_status(404)
  end
end
