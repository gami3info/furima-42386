FactoryBot.define do
  factory :purchase_shipping_address do
    # Fakerを使用してランダムなテストデータを生成します
    postal_code   { '123-4567' }
    prefecture_id { Faker::Number.between(from: 2, to: 48) } # 1(---)以外を選択
    city          { Faker::Address.city }
    street_address { Faker::Address.street_address }
    building_name { Faker::Address.secondary_address }
    phone_number  { Faker::Number.number(digits: 11).to_s }
    token         { "tok_#{Faker::Alphanumeric.alphanumeric(number: 28)}" }
  end
end
