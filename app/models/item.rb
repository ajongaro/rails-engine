class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price, :merchant_id
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def invoice_delete
    self.invoices.uniq.each do |invoice|
      invoice.destroy if invoice.items.count == 1
    end
  end
end

