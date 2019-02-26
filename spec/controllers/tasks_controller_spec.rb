require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }
  let(:task) { FactoryBot.create(:task, project: project) }

  describe '#show' do
    it 'JSON形式でレスポンスを返すこと' do
      sign_in user
      get :show, format: :json, params: { project_id: project.id, id: task.id }
      expect(response.content_type).to eq 'application/json'
    end
  end
end
