FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    email_confirmed true

    factory :admin do
      admin true
    end

    factory :user_no_confirm do #пользователь с не подтвержденным email
    	email_confirmed false
    end
    
  end
end
