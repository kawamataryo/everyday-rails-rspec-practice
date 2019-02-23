require 'rails_helper'

RSpec.describe Note, type: :model do

  describe '文字列に一致するメッセージを検索する' do
    before do
      user = User.create(
        first_name: 'B',
        last_name: 'B',
        email: 'hoge@hoge.com',
        password: '123456'
      )
      project = user.projects.create(name: 'test')
      @note1 = project.notes.create(
        message: 'this is a pen',
        user: user
      )
      @note2 = project.notes.create(
        message: 'this is a cat',
        user: user
      )
    end

    context '一致するデータがある時' do
      it '検索文字列に一致するメモを返すこと' do
        expect(Note.search('is')).to include(@note1, @note2)
        expect(Note.search('pen')).to include(@note1)
      end
    end
    context '一致するデータがない時' do
      it '検索結果が一見も見つからなければ空のコレクションを返すこと' do
        expect(Note.search('doresed')).to be_empty
      end
    end
  end
end
