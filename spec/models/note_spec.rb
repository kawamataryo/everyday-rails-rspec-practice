require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { FactoryBot.create(:user)}
  let(:project) { FactoryBot.create(:project, owner: user)}

  it 'ユーザー、プロジェクト、メッセージがあれば有効な状態であること' do
    note = Note.new(message: 'hoge', project: project, user: user)
    expect(note).to be_valid
  end

  it 'メッセージがなければ無効な状態であること' do
    note = Note.new(message: nil, project: project, user: user)
    expect(note).not_to be_valid
  end

  it '名前の取得をメモを作成したユーザーに委譲すること' do
    user = FactoryBot.create(:user, first_name: "Fake", last_name: "User")
    note = Note.new(user: user)
    expect(note.user_name).to eq "Fake User"
  end

  it 'hello worldのメソッドをメモに委譲すること' do
    project = FactoryBot.create(:project, name: "Fake")
    note = Note.new(project: project)
    expect(note.project_hello_world).to eq "hello delegate projects Fake"
  end

  describe '文字列に一致するメッセージを検索する' do
    let!(:note1) { FactoryBot.create(:note, message: 'this is a pen') }
    let!(:note2) { FactoryBot.create(:note, message: 'this is a cat') }

    context '一致するデータがある時' do
      it '検索文字列に一致するメモを返すこと' do
        expect(Note.search('is')).to include(note1, note2)
        expect(Note.search('pen')).to include(note1)
      end
    end
    context '一致するデータがない時' do
      it '検索結果が一見も見つからなければ空のコレクションを返すこと' do
        expect(Note.search('doresed')).to be_empty
        expect(Note.count).to eq 2
      end
    end
  end
end
