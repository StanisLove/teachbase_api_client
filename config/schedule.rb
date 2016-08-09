every 30.minutes do
  runner "RequestAndSaveJob.perform_now"
end
