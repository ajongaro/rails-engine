class Invoice < ApplicationRecord
  validates_presence_of :status, :customer_id, :merchant_id
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
end