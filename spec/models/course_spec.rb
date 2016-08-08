require 'rails_helper'

RSpec.describe Course, type: :model do
  [:name, :description, :owner_name, :course_id, :course_updated_at].each do |attr|
    it { should validate_presence_of attr }
  end

  describe ".save_into_db" do
    stubs = Faraday::Adapter::Test::Stubs.new
    test  = Faraday.new do |builder|
      builder.adapter :test, stubs do |stub|
      end
    end
    file = File.read("#{Rails.root}/spec/factories/items.json")
    stubs.get('/200')     { |env| [200, {}, Oj.load(file)] }
    stubs.get('/404')     { |env| [404, {}, Oj.load(file)] }

    context "200 status, valid body" do
      resp = test.get '/200'

      it "saves data into DB" do
        expect { Course.save_into_db(resp) }.to change(Course, :count).by(1)
      end

      it "doesn't duplicate data" do
        Course.save_into_db(resp)
        expect { Course.save_into_db(resp) }.not_to change(Course, :count)
      end

      it "creates course with 200 response_status" do
        Course.save_into_db(resp)
        expect(Course.first.response_status).to eq 200
      end

      context "existed course with 404 response_status" do
        let(:course) { create(:course, response_status: 404) }
        it "changes status to 200" do
          expect {
            Course.save_into_db(resp) && course.reload
          }.to change(course, :response_status).from(404).to(200)
        end
      end

      context "fake course exists" do
        let(:course) { create(:course, course_id: 0) }
        it "delete fake course from DB" do
          expect { Course.save_into_db(resp) }.to change(Course, :count).by(1)
          expect(Course.find_by_course_id(0)).to eq nil
        end
      end

      context "updated course" do
        let(:course) { create(:course, course_id: resp.body.first['course_id']) }
        it "updates course" do
          expect {
            Course.save_into_db(resp) && course.reload
          }.to change(course, :course_updated_at)
        end
      end
    end

    context "404 status" do
      resp = test.get '/404'

      it "creates fake_course with 404 status" do
        Course.save_into_db(resp)
        expect(Course.first.course_id).to eq 0
        expect(Course.first.response_status).to eq 404
      end

      context "existed course with 200 response status" do
        let(:course) { create(:course, response_status: 200) }

        it "changes status to 404 and updated_at" do
          expect {
            Course.save_into_db(resp) && course.reload
          }.to change(course, :response_status).from(200).to(404)
          .and change(course, :updated_at)
        end
      end
    end
  end
end
