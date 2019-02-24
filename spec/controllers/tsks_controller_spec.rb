require 'rails_helper'

RSpec.describe TsksController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, owner: @user)
    @task = @project.tasks.create!(name: "Test task")
  end

  describe "#show" do
    it 'JSON形式でレスポンスを返すこと' do
      sign_in @user
      get :show, format: :json, params: { project_id: @project.id, id: @task.id }
      expect(response.content_type).to eq 'application/json'

    end

  end

end
