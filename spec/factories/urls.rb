FactoryGirl.define do
  factory :url do
    long_url {|n| "MyLongText#{n}"}
    short_url {}
    sanitize_url {}
  end
end
