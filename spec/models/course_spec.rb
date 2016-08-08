require 'rails_helper'

RSpec.describe Course, type: :model do
  [:name, :description, :owner_name, :course_id, :course_updated_at].each do |attr|
    it { should validate_presence_of attr }
  end

  describe ".save_into_db" do
    let(:items) { Oj.load(File.read("#{Rails.root}/spec/factories/items.json")) }

    it "saves data into DB" do
      expect { Course.save_into_db(items) }.to change(Course, :count).by(1)
    end

    it "doesn't duplicate data" do
      Course.save_into_db(items)
      expect { Course.save_into_db(items) }.not_to change(Course, :count)
    end
  end
end
