class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items

  def self.find_all_by_name_fragment(name_fragment)
    where("name ILIKE ?", "%#{name_fragment}%").order(Arel.sql("LOWER(name)"))
  end
end