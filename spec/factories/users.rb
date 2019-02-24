FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name 'ryo'
    last_name 'kawamata'
    sequence(:email) { |n| "hoge#{n}@hoge.com" }
    password 'hogehoge'
  end
end
