require 'rails_helper'

RSpec.describe Project, type: :model do
  it "ユーザー単位で重複したプロジェクト名を許可しないこと" do
    user = User.create(
      first_name: "ryo",
      last_name: "kawamata",
      email: "hoge@hoge.com",
      password: "123456"
    )
    user.projects.create(
      name: "test project"
    )
    new_project = user.projects.build(
      name: "test project"
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "二人のユーザーが同じプロジェクト名を使うことを許可すること" do
    user = User.create(
      first_name: "B",
      last_name: "B",
      email: "hoge@hoge.com",
      password: "123456"
    )
    user.projects.create(name: "test project")

    otherUser = User.create(
      first_name: "B",
      last_name: "B",
      email: "fuga@fuga.com",
      password: "123456"
    )
    otherProject = otherUser.projects.build(name: "test project")
    expect(otherProject).to be_valid
  end

end
