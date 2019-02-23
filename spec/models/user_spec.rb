require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.new(
      first_name: "ryo",
      last_name: "kawamata",
      email: "hoge@hoge.com",
      password: "123456"
    )
  end

  it '姓、名、メールアドレス、パスワードがあれば有効な状態であること' do
    expect(user).to be_valid
  end
  it '名がなければ無効な状態であること' do
    user.first_name = nil
    user.valid?
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include "can't be blank"
  end
  it '姓がなければ無効な状態であること' do
    user.last_name = nil
    user.valid?
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include "can't be blank"
  end
  it 'メールアドレスがなければ無効な状態であること' do
    user.email = nil
    user.valid?
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include "can't be blank"
  end
  it '重複したメールアドレスがあれば無効な状態であること' do
    user.save
    overlappedEmailUser = User.new(
      first_name: "r",
      last_name: "k",
      email: user.email,
      password: "1"
    )
    overlappedEmailUser.valid?
    expect(overlappedEmailUser).not_to be_valid
    expect(overlappedEmailUser.errors[:email]).to include "has already been taken"
  end
  it 'ユーザーのフルネームを文字列として返すこと' do
    expect(user.name).to eq "ryo kawamata"
  end
end
