require 'rails_helper'

RSpec.describe CoursesController, type: :controller do

  describe 'GET #index' do

    context "status 200" do
      let!(:courses) { create_list(:course, 4, response_status: 200) }

      it 'assigns courses' do
        get :index
        expect(assigns(:courses).inspect).to eq Course.page(1).per(2).inspect
      end

      it 'renders template' do
        get :index
        expect(response).to render_template :index
      end

      it "doesn't alerts that server is down" do
        get :index
        expect(flash[:alert]).not_to be_present
      end

       it 'sends request' do
         expect(Course).to receive(:request_and_save)
         get :index
       end
    end

    context "status 404" do
      let!(:courses) { create_list(:course, 4, response_status: 404) }

      it 'assigns courses' do
        get :index
        expect(assigns(:courses).inspect).to eq Course.page(1).per(1).inspect
      end

      it 'renders template' do
        get :index
        expect(response).to render_template :index
      end

      it 'alerts that server is down' do
        get :index
        expect(flash[:alert]).to be_present
      end

       it 'does not send request' do
         expect(Course).not_to receive(:request_and_save)
         get :index
       end
    end
  end

end
