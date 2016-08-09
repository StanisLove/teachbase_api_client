require 'rails_helper'

RSpec.describe RequestAndSaveJob, type: :job do
  context "there are no courses with 404 status" do
    let!(:course) { create(:course, response_status: 200) }
    it "sends request" do
      expect(Course).not_to receive(:request_and_save)
      described_class.perform_now
    end
  end

  context "there are courses with 404 status" do
    let!(:course) { create(:course, response_status: 404) }
    it "sends request" do
      expect(Course).to receive(:request_and_save)
      described_class.perform_now
    end
  end
end
