require 'rails_helper'

RSpec.describe Course, type: :model do
  [:name, :description, :owner_name, :course_id, :course_updated_at].each do |attr|
    it { should validate_presence_of attr }
  end
end
