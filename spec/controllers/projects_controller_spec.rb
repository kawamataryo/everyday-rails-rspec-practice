require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe '#index' do
    before do
      @user = FactoryBot.create(:user)
    end

    context '認証済みユーザーの場合' do
      it '200レスポンスを返すこと' do
        sign_in @user
        get :index
        expect(response).to have_http_status 200
      end
    end

    context 'ゲストユーザーの場合' do
      it '302レスポンスを返すこと' do
        get :index
        expect(response).to have_http_status 302
      end

      it 'サインイン画面にリダイレクトすること' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#show' do
    context '認可されたユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it '正常にレスポンスを返すこと' do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to have_http_status 200
      end
    end

    context '認可されていないユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it 'ダッシュボードにリダイレクトすること' do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#create' do
    context '認証済みユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
      end

      context '有効な属性値の場合' do
        it 'プロジェクトを追加できること' do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect {
            post :create, params: { project: project_params }
          }.to change(@user.projects, :count).by(1)
        end
      end

      context '無効な属性値の場合' do
        it 'プロジェクトの追加に失敗すること' do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect {
            post :create, params: { project: project_params }
          }.to_not change(@user.projects, :count)
        end
      end
    end

    it 'ゲストの場合' do
      project_params = FactoryBot.attributes_for(:project)
      post :create, params: { project: project_params }
      expect(response).to have_http_status 302
      expect(response).to redirect_to '/users/sign_in'
    end
  end

  describe '#update' do
    context '認可されているユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'プロジェクトを編集できること' do
        update_params = FactoryBot.attributes_for(:project, name: 'updated project')
        sign_in @user
        patch :update, params: { id: @project.id, project: update_params }
        expect(@project.reload.name).to eq 'updated project'
      end
    end

    context '認可されていないユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end
      it 'プロジェクトを編集できないこと' do
        update_params = FactoryBot.attributes_for(:project, name: 'updated project')
        sign_in @user
        patch :update, params: { id: @project.id, project: update_params }
        expect(@project.reload.name).to eq @project.name
      end
      it '302でルートにリダイレクトされること' do
        update_params = FactoryBot.attributes_for(:project, name: 'updated project')
        sign_in @user
        patch :update, params: { id: @project.id, project: update_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#destroy' do
    context '認可されているユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'プロジェクトの削除が出来ること' do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change { @user.projects.count }.by(-1)
      end
    end

    context '認可されていないユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it 'プロジェクトの削除が出来ないこと' do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change { @user.projects.count }.by(0)
      end

      it '302でルートにリダイレクトされること' do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
    end
  end
end


