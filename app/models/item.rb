class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price, :merchant_id 
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items

  def invoice_delete
    self.invoices.uniq.each do |invoice|
      invoice.destroy if invoice.items.count == 1
    end
  end

  def self.find_all_by_name_fragment(name_fragment)
    where("name ILIKE ?", "%#{name_fragment}%").order(Arel.sql("LOWER(name)"))
  end
end

