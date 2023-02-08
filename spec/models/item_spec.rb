require 'rails_helper'

RSpec.describe Item, type: :model do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
  let!(:customer1) { create(:customer) }
  let!(:item1) { create(:item, merchant: merchant1) }
  let!(:item2) { create(:item, merchant: merchant1) }
  let!(:item3) { create(:item, merchant: merchant1) }
  let!(:invoice1) { Invoice.create!(status: "shipped", customer: customer1, merchant: merchant1) }
  let!(:invoice2) { Invoice.create!(status: "shipped", customer: customer1, merchant: merchant1) }
  let!(:invoice3) { Invoice.create!(status: "shipped", customer: customer1, merchant: merchant1) }

  # two items on invoice1
  let!(:invoice_item1) { InvoiceItem.create!(item: item1, quantity: 10, unit_price: 100.02, invoice: invoice1) }
  let!(:invoice_item2) { InvoiceItem.create!(item: item2, quantity: 10, unit_price: 109.04, invoice: invoice1) }

  # one item on invoice2 
  let!(:invoice_item3) { InvoiceItem.create!(item: item1, quantity: 10, unit_price: 115.07, invoice: invoice2) }

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe '#invoice_delete' do
    it 'deletes invoice if item is the only item on invoice' do
      expect(Invoice.count).to eq(3)

      item1.invoice_delete

      expect(Invoice.count).to eq(2)

      expect(Invoice.find(invoice1.id)).to eq(invoice1)
      
      expect { Invoice.find(invoice2.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end