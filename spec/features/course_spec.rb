require "features_helper"

feature 'User browse courses' do

  context 'api server available' do
    let!(:courses) { create_list(:course, 4, response_status: 200) }

    scenario 'visit root path' do
      visit root_path

      within "ul.list" do
        expect(page).to have_selector('.list-item', count: 2)
      end
      expect(page).to have_selector('.pagination')
    end
  end

  context 'api server is down less than one hour' do
    let!(:courses) { create_list(:course, 4, response_status: 404) }

    scenario 'visit root path' do
      visit root_path

      within "ul.list" do
        expect(page).to have_selector('.list-item', count: 1)
      end

      expect(page).not_to have_selector('.pagination')

      expect(page).to have_content "В данный момент Teachbase недоступен. Загружена копия от #{courses.first.updated_at.strftime("%d.%m.%Y %H:%M")}"
    end
  end

  context 'api server is down more than one hour' do
    let!(:courses) { create_list(:course, 4, response_status: 404, updated_at: Time.now - 5.1.hours) }

    scenario 'visit root path' do
      visit root_path

      within "ul.list" do
        expect(page).to have_selector('.list-item', count: 1)
      end

      expect(page).not_to have_selector('.pagination')

      expect(page).to have_content "Teachbase лежит уже 5 часов"
    end
  end
end
