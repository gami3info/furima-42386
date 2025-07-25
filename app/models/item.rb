class Item < ApplicationRecord
  belongs_to :user
  belongs_to :user
  has_one :purchase
end
