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

  def self.find_all_items_by_min(price)
    where("unit_price >= ?", price)
  end

  def self.find_all_items_by_max(price)
    where("unit_price <= ?", price)
  end

  def self.find_all_items_in_range(min, max)
    where("unit_price >= ? AND unit_price <= ?", min, max)
  end
end

