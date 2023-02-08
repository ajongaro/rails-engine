class InvoiceItem < ApplicationRecord
  validates_presence_of :unit_price, :item_id, :invoice_id, :quantity
  belongs_to :item
  belongs_to :invoice
end