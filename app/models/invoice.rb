class Invoice < ApplicationRecord
  validates_presence_of :status, :customer_id, :merchant_id
  belongs_to :merchant
  belongs_to :customer
  has_many :invoice_items, dependent: :delete_all
  has_many :items, through: :invoice_items
end