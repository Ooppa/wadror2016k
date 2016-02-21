FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :style do
    name "Example style"
    description "Example description"
  end

  factory :rating do
    user_id 1
    beer_id 1
    score 10
  end

  factory :rating2, class: Rating do
    user_id 1
    beer_id 1
    score 20
  end

  factory :brewery do
    name "Anonymous brewery"
    year 1900
  end

  factory :beer do
    name "Example beer"
    brewery
    style
  end
end
