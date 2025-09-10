class PurchaseShippingAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :street_address, :building_name, :phone_number, :token

  # バリデーション
  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)" }
    validates :city
    validates :street_address
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "is invalid" }
    validates :token # クレジットカード情報のトークン
  end

  # 都道府県の選択が「---」の時は保存できないようにする
  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }

  def save
    # 購入情報を保存し、変数purchaseに代入する
    purchase = Purchase.create(user_id: user_id, item_id: item_id)
    # 配送先を保存する
    # purchase_idには、変数purchaseのidと指定する
    ShippingAddress.create(
      postal_code: postal_code,
      prefecture_id: prefecture_id,
      city: city,
      street_address: street_address,
      building_name: building_name,
      phone_number: phone_number,
      purchase_id: purchase.id
    )
  end
end
