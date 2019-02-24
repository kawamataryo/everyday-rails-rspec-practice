require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'ユーザーのプジロジェクト作成可否' do
    let(:user) {FactoryBot.create(:user)}
    it 'ユーザー単位で重複したプロジェクト名を許可しないこと' do
      user.projects.create(
        name: 'test project'
      )
      new_project = user.projects.build(
        name: 'test project'
      )
      new_project.valid?
      expect(new_project.errors[:name]).to include('has already been taken')
    end

    it '二人のユーザーが同じプロジェクト名を使うことを許可すること' do
      user.projects.create(name: 'test project')
      other_user = FactoryBot.create(:user)
      other_project = other_user.projects.build(name: 'test project')
      expect(other_project).to be_valid
    end
  end

  describe '遅延ステータス' do
    it '締切日が過ぎていれば遅延していること' do
      project = FactoryBot.build(:project, :due_yesterday)
      expect(project).to be_late
    end
    it '締切日が今日ならスケジュールどおりであること' do
      project = FactoryBot.build(:project, :due_today)
      expect(project).to_not be_late
    end
    it '締切日が機能ならスケジュールどおりであること' do
      project = FactoryBot.build(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  describe 'コールバックの動作確認' do
    it '5件のメモが作成されること' do
      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.length).to eq 5
    end

  end

end
