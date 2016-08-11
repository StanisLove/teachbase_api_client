class RequestAndSaveJob < ActiveJob::Base
  queue_as :default

  def perform
    ResponseHandler.request_and_save if Course.find_by_response_status(404)
  end
end
